using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public class ActividadRepository : IActividadRepository
    {
        public List<ActividadDto> ListarTodas()
        {
            return ListarConFiltro(null, null, null, null);
        }

        public List<ActividadDto> ListarConFiltro(string criterio, string estado, string tipo, DateTime? fecha = null)
        {
            var lista = new List<ActividadDto>();

            string query = @"
                SELECT ActividadId, Titulo, Descripcion, Tipo, FechaInicio, FechaFin, 
                       HoraInicio, HoraFin, Modalidad, Lugar, Cupos, Estado, FechaCreacion
                FROM dbo.ActividadAcademica
                WHERE (1 = 1) ";

            if (!string.IsNullOrWhiteSpace(criterio))
            {
                query += " AND (Titulo LIKE @Criterio OR Lugar LIKE @Criterio OR Descripcion LIKE @Criterio) ";
            }
            if (!string.IsNullOrWhiteSpace(estado) && estado != "Todos")
            {
                query += " AND Estado = @Estado ";
            }
            if (!string.IsNullOrWhiteSpace(tipo) && tipo != "Todos")
            {
                query += " AND Tipo = @Tipo ";
            }
            if (fecha.HasValue && fecha.Value != DateTime.MinValue)
            {
                query += " AND (FechaInicio <= @Fecha AND FechaFin >= @Fecha) ";
            }

            query += " ORDER BY ActividadId ASC;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrWhiteSpace(criterio))
                {
                    cmd.Parameters.Add("@Criterio", SqlDbType.NVarChar, 120).Value = "%" + criterio.Trim() + "%";
                }
                if (!string.IsNullOrWhiteSpace(estado) && estado != "Todos")
                {
                    cmd.Parameters.Add("@Estado", SqlDbType.NVarChar, 20).Value = estado;
                }
                if (!string.IsNullOrWhiteSpace(tipo) && tipo != "Todos")
                {
                    cmd.Parameters.Add("@Tipo", SqlDbType.NVarChar, 50).Value = tipo;
                }
                if (fecha.HasValue && fecha.Value != DateTime.MinValue)
                {
                    cmd.Parameters.Add("@Fecha", SqlDbType.Date).Value = fecha.Value.Date;
                }

                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(MapearActividad(reader));
                    }
                }
            }

            return lista;
        }

        public ActividadDto ObtenerPorId(int id)
        {
            const string query = @"
                SELECT ActividadId, Titulo, Descripcion, Tipo, FechaInicio, FechaFin, 
                       HoraInicio, HoraFin, Modalidad, Lugar, Cupos, Estado, FechaCreacion
                FROM dbo.ActividadAcademica
                WHERE ActividadId = @Id;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapearActividad(reader);
                    }
                }
            }

            return null;
        }

        public int Insertar(ActividadDto act)
        {
            const string query = @"
                INSERT INTO dbo.ActividadAcademica 
                (Titulo, Descripcion, Tipo, FechaInicio, FechaFin, HoraInicio, HoraFin, Modalidad, Lugar, Cupos, Estado)
                OUTPUT INSERTED.ActividadId
                VALUES 
                (@Titulo, @Descripcion, @Tipo, @FechaInicio, @FechaFin, @HoraInicio, @HoraFin, @Modalidad, @Lugar, @Cupos, @Estado);";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Titulo", SqlDbType.NVarChar, 120).Value = act.Titulo;
                cmd.Parameters.Add("@Descripcion", SqlDbType.NVarChar, 1000).Value = (object)act.Descripcion ?? DBNull.Value;
                cmd.Parameters.Add("@Tipo", SqlDbType.NVarChar, 50).Value = act.Tipo;
                cmd.Parameters.Add("@FechaInicio", SqlDbType.Date).Value = act.FechaInicio;
                cmd.Parameters.Add("@FechaFin", SqlDbType.Date).Value = act.FechaFin == DateTime.MinValue ? act.FechaInicio : act.FechaFin;
                cmd.Parameters.Add("@HoraInicio", SqlDbType.NVarChar, 10).Value = act.HoraInicio ?? "08:00";
                cmd.Parameters.Add("@HoraFin", SqlDbType.NVarChar, 10).Value = act.HoraFin ?? "10:00";
                cmd.Parameters.Add("@Modalidad", SqlDbType.NVarChar, 50).Value = act.Modalidad ?? "Presencial";
                cmd.Parameters.Add("@Lugar", SqlDbType.NVarChar, 150).Value = act.Lugar ?? "Campus";
                cmd.Parameters.Add("@Cupos", SqlDbType.Int).Value = act.Cupos;
                cmd.Parameters.Add("@Estado", SqlDbType.NVarChar, 20).Value = act.Estado ?? "Activa";

                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public bool Actualizar(ActividadDto act)
        {
            const string query = @"
                UPDATE dbo.ActividadAcademica
                SET Titulo = @Titulo,
                    Descripcion = @Descripcion,
                    Tipo = @Tipo,
                    FechaInicio = @FechaInicio,
                    FechaFin = @FechaFin,
                    HoraInicio = @HoraInicio,
                    HoraFin = @HoraFin,
                    Modalidad = @Modalidad,
                    Lugar = @Lugar,
                    Cupos = @Cupos,
                    Estado = @Estado
                WHERE ActividadId = @ActividadId;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@ActividadId", SqlDbType.Int).Value = act.ActividadId;
                cmd.Parameters.Add("@Titulo", SqlDbType.NVarChar, 120).Value = act.Titulo;
                cmd.Parameters.Add("@Descripcion", SqlDbType.NVarChar, 1000).Value = (object)act.Descripcion ?? DBNull.Value;
                cmd.Parameters.Add("@Tipo", SqlDbType.NVarChar, 50).Value = act.Tipo;
                cmd.Parameters.Add("@FechaInicio", SqlDbType.Date).Value = act.FechaInicio;
                cmd.Parameters.Add("@FechaFin", SqlDbType.Date).Value = act.FechaFin == DateTime.MinValue ? act.FechaInicio : act.FechaFin;
                cmd.Parameters.Add("@HoraInicio", SqlDbType.NVarChar, 10).Value = act.HoraInicio ?? "08:00";
                cmd.Parameters.Add("@HoraFin", SqlDbType.NVarChar, 10).Value = act.HoraFin ?? "10:00";
                cmd.Parameters.Add("@Modalidad", SqlDbType.NVarChar, 50).Value = act.Modalidad ?? "Presencial";
                cmd.Parameters.Add("@Lugar", SqlDbType.NVarChar, 150).Value = act.Lugar ?? "Campus";
                cmd.Parameters.Add("@Cupos", SqlDbType.Int).Value = act.Cupos;
                cmd.Parameters.Add("@Estado", SqlDbType.NVarChar, 20).Value = act.Estado ?? "Activa";

                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool Eliminar(int id)
        {
            const string query = @"
                DELETE FROM dbo.ActividadAcademica
                WHERE ActividadId = @Id;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public EstadisticasDto ObtenerEstadisticas()
        {
            const string query = @"
                SELECT 
                    (SELECT COUNT(1) FROM dbo.ActividadAcademica WHERE Estado != 'Cancelada') AS TotalActividades,
                    (SELECT COUNT(1) FROM dbo.Inscripcion WHERE Estado = 'Activa') AS TotalInscritos,
                    (SELECT COUNT(1) FROM dbo.ActividadAcademica WHERE Estado = 'Próxima') AS ActividadesProximas,
                    (SELECT COUNT(1) FROM dbo.ActividadAcademica WHERE Estado = 'Finalizada') AS ActividadesFinalizadas;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new EstadisticasDto
                        {
                            TotalActividades = reader.GetInt32(0),
                            TotalInscritos = reader.GetInt32(1),
                            ActividadesProximas = reader.GetInt32(2),
                            ActividadesFinalizadas = reader.GetInt32(3)
                        };
                    }
                }
            }

            return new EstadisticasDto();
        }

        private static ActividadDto MapearActividad(IDataRecord reader)
        {
            return new ActividadDto
            {
                ActividadId = reader.GetInt32(reader.GetOrdinal("ActividadId")),
                Titulo = reader.GetString(reader.GetOrdinal("Titulo")),
                Descripcion = reader.IsDBNull(reader.GetOrdinal("Descripcion")) ? "" : reader.GetString(reader.GetOrdinal("Descripcion")),
                Tipo = reader.GetString(reader.GetOrdinal("Tipo")),
                FechaInicio = reader.GetDateTime(reader.GetOrdinal("FechaInicio")),
                FechaFin = reader.GetDateTime(reader.GetOrdinal("FechaFin")),
                HoraInicio = reader.IsDBNull(reader.GetOrdinal("HoraInicio")) ? "" : reader.GetString(reader.GetOrdinal("HoraInicio")),
                HoraFin = reader.IsDBNull(reader.GetOrdinal("HoraFin")) ? "" : reader.GetString(reader.GetOrdinal("HoraFin")),
                Modalidad = reader.GetString(reader.GetOrdinal("Modalidad")),
                Lugar = reader.GetString(reader.GetOrdinal("Lugar")),
                Cupos = reader.GetInt32(reader.GetOrdinal("Cupos")),
                Estado = reader.GetString(reader.GetOrdinal("Estado")),
                FechaCreacion = reader.GetDateTime(reader.GetOrdinal("FechaCreacion"))
            };
        }
    }
}
