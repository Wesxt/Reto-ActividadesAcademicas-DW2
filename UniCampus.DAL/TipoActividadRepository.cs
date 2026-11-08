using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public class TipoActividadRepository : ITipoActividadRepository
    {
        public List<TipoActividadDto> ListarTodos()
        {
            var lista = new List<TipoActividadDto>();
            const string query = "SELECT TipoId, Nombre, Descripcion FROM dbo.TipoActividad ORDER BY Nombre ASC;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new TipoActividadDto
                        {
                            TipoId = reader.GetInt32(0),
                            Nombre = reader.GetString(1),
                            Descripcion = reader.IsDBNull(2) ? "" : reader.GetString(2)
                        });
                    }
                }
            }

            return lista;
        }

        public bool Existe(string nombre)
        {
            const string query = "SELECT COUNT(1) FROM dbo.TipoActividad WHERE Nombre = @Nombre;";
            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Nombre", SqlDbType.NVarChar, 50).Value = nombre.Trim();
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        public int Insertar(TipoActividadDto tipo)
        {
            const string query = @"
                INSERT INTO dbo.TipoActividad (Nombre, Descripcion)
                OUTPUT INSERTED.TipoId
                VALUES (@Nombre, @Descripcion);";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Nombre", SqlDbType.NVarChar, 50).Value = tipo.Nombre.Trim();
                cmd.Parameters.Add("@Descripcion", SqlDbType.NVarChar, 250).Value = (object)tipo.Descripcion ?? DBNull.Value;
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public bool Eliminar(int tipoId)
        {
            const string query = "DELETE FROM dbo.TipoActividad WHERE TipoId = @Id;";
            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = tipoId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}
