using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public class InscripcionRepository : IInscripcionRepository
    {
        public List<InscripcionDto> ListarPorActividad(int actividadId)
        {
            var lista = new List<InscripcionDto>();

            const string query = @"
                SELECT i.InscripcionId, i.ActividadId, a.Titulo AS TituloActividad,
                       u.UsuarioId, u.Nombre AS EstudianteNombre, u.Correo AS EstudianteCorreo,
                       u.Programa AS EstudiantePrograma, i.FechaInscripcion, i.Estado
                FROM dbo.Inscripcion i
                INNER JOIN dbo.Usuario u ON i.UsuarioId = u.UsuarioId
                INNER JOIN dbo.ActividadAcademica a ON i.ActividadId = a.ActividadId
                WHERE i.ActividadId = @ActividadId AND i.Estado = 'Activa'
                ORDER BY i.FechaInscripcion DESC;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new InscripcionDto
                        {
                            InscripcionId = reader.GetInt32(0),
                            ActividadId = reader.GetInt32(1),
                            TituloActividad = reader.GetString(2),
                            UsuarioId = reader.GetInt32(3),
                            EstudianteNombre = reader.GetString(4),
                            EstudianteCorreo = reader.GetString(5),
                            EstudiantePrograma = reader.GetString(6),
                            FechaInscripcion = reader.GetDateTime(7),
                            Estado = reader.GetString(8)
                        });
                    }
                }
            }

            return lista;
        }

        public bool EstaInscrito(int actividadId, int usuarioId)
        {
            const string query = @"
                SELECT COUNT(1)
                FROM dbo.Inscripcion
                WHERE ActividadId = @ActividadId AND UsuarioId = @UsuarioId AND Estado = 'Activa';";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                cmd.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuarioId;
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        public ResultadoOperacion Inscribir(int actividadId, int usuarioId)
        {
            using (var con = ConexionDb.CrearConexion())
            {
                con.Open();
                using (var trans = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Validar que la actividad existe y tiene cupos (bloqueo exclusivo para evitar concurrencia)
                        const string sqlActividad = @"
                            SELECT Cupos, Estado 
                            FROM dbo.ActividadAcademica WITH (UPDLOCK, ROWLOCK)
                            WHERE ActividadId = @ActividadId;";

                        int cuposDisponibles;
                        string estado;

                        using (var cmdAct = new SqlCommand(sqlActividad, con, trans))
                        {
                            cmdAct.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            using (var reader = cmdAct.ExecuteReader())
                            {
                                if (!reader.Read())
                                {
                                    trans.Rollback();
                                    return ResultadoOperacion.Fallo("La actividad seleccionada no existe.");
                                }
                                cuposDisponibles = reader.GetInt32(0);
                                estado = reader.GetString(1);
                            }
                        }

                        if (estado != "Activa" && estado != "Próxima")
                        {
                            trans.Rollback();
                            return ResultadoOperacion.Fallo($"No es posible inscribirse en una actividad con estado '{estado}'.");
                        }

                        if (cuposDisponibles <= 0)
                        {
                            trans.Rollback();
                            return ResultadoOperacion.Fallo("No hay cupos disponibles para esta actividad.");
                        }

                        // 2. Verificar duplicados
                        const string sqlCheck = @"
                            SELECT COUNT(1) 
                            FROM dbo.Inscripcion 
                            WHERE ActividadId = @ActividadId AND UsuarioId = @UsuarioId AND Estado = 'Activa';";

                        using (var cmdCheck = new SqlCommand(sqlCheck, con, trans))
                        {
                            cmdCheck.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            cmdCheck.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuarioId;
                            int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                            if (count > 0)
                            {
                                trans.Rollback();
                                return ResultadoOperacion.Fallo("El estudiante ya se encuentra inscrito en esta actividad.");
                            }
                        }

                        // 3. Insertar la inscripción
                        const string sqlInsert = @"
                            INSERT INTO dbo.Inscripcion (ActividadId, UsuarioId, FechaInscripcion, Estado)
                            OUTPUT INSERTED.InscripcionId
                            VALUES (@ActividadId, @UsuarioId, SYSUTCDATETIME(), 'Activa');";

                        int inscripcionId;
                        using (var cmdInsert = new SqlCommand(sqlInsert, con, trans))
                        {
                            cmdInsert.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            cmdInsert.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuarioId;
                            inscripcionId = Convert.ToInt32(cmdInsert.ExecuteScalar());
                        }

                        // 4. Descontar cupo
                        const string sqlUpdateCupos = @"
                            UPDATE dbo.ActividadAcademica
                            SET Cupos = Cupos - 1
                            WHERE ActividadId = @ActividadId AND Cupos > 0;";

                        using (var cmdCupos = new SqlCommand(sqlUpdateCupos, con, trans))
                        {
                            cmdCupos.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            cmdCupos.ExecuteNonQuery();
                        }

                        trans.Commit();
                        return ResultadoOperacion.Ok("Inscripción realizada exitosamente.", inscripcionId);
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        return ResultadoOperacion.Fallo("Error al procesar la inscripción: " + ex.Message);
                    }
                }
            }
        }

        public ResultadoOperacion CancelarInscripcion(int inscripcionId)
        {
            using (var con = ConexionDb.CrearConexion())
            {
                con.Open();
                using (var trans = con.BeginTransaction())
                {
                    try
                    {
                        int actividadId;
                        const string sqlGet = "SELECT ActividadId, Estado FROM dbo.Inscripcion WHERE InscripcionId = @Id;";
                        using (var cmdGet = new SqlCommand(sqlGet, con, trans))
                        {
                            cmdGet.Parameters.Add("@Id", SqlDbType.Int).Value = inscripcionId;
                            using (var r = cmdGet.ExecuteReader())
                            {
                                if (!r.Read())
                                {
                                    trans.Rollback();
                                    return ResultadoOperacion.Fallo("La inscripción no existe.");
                                }
                                actividadId = r.GetInt32(0);
                                string est = r.GetString(1);
                                if (est != "Activa")
                                {
                                    trans.Rollback();
                                    return ResultadoOperacion.Fallo("La inscripción ya no está activa.");
                                }
                            }
                        }

                        const string sqlUpdate = "UPDATE dbo.Inscripcion SET Estado = 'Cancelada' WHERE InscripcionId = @Id;";
                        using (var cmdUp = new SqlCommand(sqlUpdate, con, trans))
                        {
                            cmdUp.Parameters.Add("@Id", SqlDbType.Int).Value = inscripcionId;
                            cmdUp.ExecuteNonQuery();
                        }

                        const string sqlRestaurarCupo = "UPDATE dbo.ActividadAcademica SET Cupos = Cupos + 1 WHERE ActividadId = @ActividadId;";
                        using (var cmdCupos = new SqlCommand(sqlRestaurarCupo, con, trans))
                        {
                            cmdCupos.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            cmdCupos.ExecuteNonQuery();
                        }

                        trans.Commit();
                        return ResultadoOperacion.Ok("Inscripción cancelada y cupo restaurado.");
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        return ResultadoOperacion.Fallo("Error al cancelar la inscripción: " + ex.Message);
                    }
                }
            }
        }
    }
}
