using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public class ResenaRepository : IResenaRepository
    {
        public List<ResenaDto> ListarPorActividad(int actividadId)
        {
            var lista = new List<ResenaDto>();

            const string query = @"
                SELECT r.ResenaId, r.ActividadId, r.UsuarioId, u.Nombre AS UsuarioNombre,
                       u.Programa AS UsuarioPrograma, r.Calificacion, r.Comentario, r.FechaCreacion
                FROM dbo.Resena r
                INNER JOIN dbo.Usuario u ON r.UsuarioId = u.UsuarioId
                WHERE r.ActividadId = @ActividadId
                ORDER BY r.FechaCreacion DESC;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new ResenaDto
                        {
                            ResenaId = reader.GetInt32(0),
                            ActividadId = reader.GetInt32(1),
                            UsuarioId = reader.GetInt32(2),
                            UsuarioNombre = reader.GetString(3),
                            UsuarioPrograma = reader.GetString(4),
                            Calificacion = Convert.ToInt32(reader.GetByte(5)),
                            Comentario = reader.IsDBNull(6) ? "" : reader.GetString(6),
                            FechaCreacion = reader.GetDateTime(7)
                        });
                    }
                }
            }

            return lista;
        }

        public bool ExisteResena(int actividadId, int usuarioId)
        {
            const string query = @"
                SELECT COUNT(1) 
                FROM dbo.Resena 
                WHERE ActividadId = @ActividadId AND UsuarioId = @UsuarioId;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@ActividadId", SqlDbType.Int).Value = actividadId;
                cmd.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = usuarioId;
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        public int Insertar(ResenaDto r)
        {
            const string query = @"
                INSERT INTO dbo.Resena (ActividadId, UsuarioId, Calificacion, Comentario)
                OUTPUT INSERTED.ResenaId
                VALUES (@ActividadId, @UsuarioId, @Calificacion, @Comentario);";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@ActividadId", SqlDbType.Int).Value = r.ActividadId;
                cmd.Parameters.Add("@UsuarioId", SqlDbType.Int).Value = r.UsuarioId;
                cmd.Parameters.Add("@Calificacion", SqlDbType.TinyInt).Value = (byte)r.Calificacion;
                cmd.Parameters.Add("@Comentario", SqlDbType.NVarChar, 1000).Value = (object)r.Comentario ?? DBNull.Value;

                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public bool Eliminar(int resenaId)
        {
            const string query = "DELETE FROM dbo.Resena WHERE ResenaId = @Id;";
            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = resenaId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}
