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

                        bool actividadExiste = false;
                        int cuposDisponibles = 0;
                        string estado = null;

                        using (var cmdAct = new SqlCommand(sqlActividad, con, trans))
                        {
                            cmdAct.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            using (var reader = cmdAct.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    actividadExiste = true;
                                    cuposDisponibles = reader.GetInt32(0);
                                    estado = reader.GetString(1);
                                }
                            }
                        }

                        if (!actividadExiste)
                        {
                            trans.Rollback();
                            return ResultadoOperacion.Fallo("La actividad seleccionada no existe.");
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

                        // 2. Verificar si ya existe una inscripción previa
                        const string sqlCheck = @"
                            SELECT InscripcionId, Estado 
                            FROM dbo.Inscripcion 
                            WHERE ActividadId = @ActividadId AND UsuarioId = @UsuarioId;";

                        int inscripcionPreviaId = 0;
                        string estadoPrevio = null;

                        using (var cmdCheck = new SqlCommand(sqlCheck, con, trans))
                        {
                            cmdCheck.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                            cmdCheck.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuarioId;
                            using (var readerCheck = cmdCheck.ExecuteReader())
                            {
                                if (readerCheck.Read())
                                {
                                    inscripcionPreviaId = readerCheck.GetInt32(0);
                                    estadoPrevio = readerCheck.GetString(1);
                                }
                            }
                        }

                        if (inscripcionPreviaId > 0 && estadoPrevio == "Activa")
                        {
                            trans.Rollback();
                            return ResultadoOperacion.Fallo("El estudiante ya se encuentra inscrito en esta actividad.");
                        }

                        int finalInscripcionId;

                        if (inscripcionPreviaId > 0)
                        {
                            // Reactivar la inscripción previa para evitar violación del índice UNIQUE
                            const string sqlReactivar = @"
                                UPDATE dbo.Inscripcion 
                                SET Estado = 'Activa', FechaInscripcion = SYSUTCDATETIME()
                                WHERE InscripcionId = @Id;";

                            using (var cmdReactivar = new SqlCommand(sqlReactivar, con, trans))
                            {
                                cmdReactivar.Parameters.Add("@Id", SqlDbType.Int).Value = inscripcionPreviaId;
                                cmdReactivar.ExecuteNonQuery();
                            }
                            finalInscripcionId = inscripcionPreviaId;
                        }
                        else
                        {
                            // 3. Insertar la inscripción nueva
                            const string sqlInsert = @"
                                INSERT INTO dbo.Inscripcion (ActividadId, UsuarioId, FechaInscripcion, Estado)
                                OUTPUT INSERTED.InscripcionId
                                VALUES (@ActividadId, @UsuarioId, SYSUTCDATETIME(), 'Activa');";

                            using (var cmdInsert = new SqlCommand(sqlInsert, con, trans))
                            {
                                cmdInsert.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                                cmdInsert.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuarioId;
                                finalInscripcionId = Convert.ToInt32(cmdInsert.ExecuteScalar());
                            }
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
                        return ResultadoOperacion.Ok("Inscripción realizada exitosamente.", finalInscripcionId);
                    }
                    catch (Exception ex)
                    {
                        try { trans.Rollback(); } catch { }
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
                        int actividadId = 0;
                        string estado = null;

                        const string sqlGet = "SELECT ActividadId, Estado FROM dbo.Inscripcion WHERE InscripcionId = @Id;";
                        using (var cmdGet = new SqlCommand(sqlGet, con, trans))
                        {
                            cmdGet.Parameters.Add("@Id", SqlDbType.Int).Value = inscripcionId;
                            using (var r = cmdGet.ExecuteReader())
                            {
                                if (r.Read())
                                {
                                    actividadId = r.GetInt32(0);
                                    estado = r.GetString(1);
                                }
                            }
                        }

                        if (actividadId == 0)
                        {
                            trans.Rollback();
                            return ResultadoOperacion.Fallo("La inscripción no existe o ya fue removida.");
                        }

                        // Eliminar registro de inscripción para liberar la restricción UNIQUE
                        const string sqlDelete = "DELETE FROM dbo.Inscripcion WHERE InscripcionId = @Id;";
                        using (var cmdDel = new SqlCommand(sqlDelete, con, trans))
                        {
                            cmdDel.Parameters.Add("@Id", SqlDbType.Int).Value = inscripcionId;
                            cmdDel.ExecuteNonQuery();
                        }

                        // Restaurar cupo en la actividad
                        if (estado == "Activa")
                        {
                            const string sqlRestaurarCupo = "UPDATE dbo.ActividadAcademica SET Cupos = Cupos + 1 WHERE ActividadId = @ActividadId;";
                            using (var cmdCupos = new SqlCommand(sqlRestaurarCupo, con, trans))
                            {
                                cmdCupos.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                                cmdCupos.ExecuteNonQuery();
                            }
                        }

                        trans.Commit();
                        return ResultadoOperacion.Ok("Inscripción cancelada exitosamente y cupo restaurado.");
                    }
                    catch (Exception ex)
                    {
                        try { trans.Rollback(); } catch { }
                        return ResultadoOperacion.Fallo("Error al cancelar la inscripción: " + ex.Message);
                    }
                }
            }
        }
    }
}
