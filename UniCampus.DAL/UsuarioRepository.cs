using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public class UsuarioRepository : IUsuarioRepository
    {
        public List<UsuarioDto> ListarEstudiantes()
        {
            var lista = new List<UsuarioDto>();

            const string query = @"
                SELECT UsuarioId, Nombre, Correo, Clave, Programa, Rol, Telefono, FechaRegistro
                FROM dbo.Usuario
                WHERE Rol = 'Estudiante'
                ORDER BY Nombre ASC;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(MapearUsuario(reader));
                    }
                }
            }

            return lista;
        }

        public List<UsuarioDto> ListarTodos()
        {
            var lista = new List<UsuarioDto>();

            const string query = @"
                SELECT UsuarioId, Nombre, Correo, Clave, Programa, Rol, Telefono, FechaRegistro
                FROM dbo.Usuario
                ORDER BY Rol DESC, Nombre ASC;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(MapearUsuario(reader));
                    }
                }
            }

            return lista;
        }

        public bool ActualizarRol(int usuarioId, string nuevoRol)
        {
            const string query = @"
                UPDATE dbo.Usuario
                SET Rol = @Rol
                WHERE UsuarioId = @Id;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Rol", SqlDbType.NVarChar, 30).Value = nuevoRol;
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = usuarioId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool EliminarUsuario(int usuarioId)
        {
            const string query = "DELETE FROM dbo.Usuario WHERE UsuarioId = @Id;";
            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = usuarioId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public UsuarioDto ObtenerPorId(int id)
        {
            const string query = @"
                SELECT UsuarioId, Nombre, Correo, Clave, Programa, Rol, Telefono, FechaRegistro
                FROM dbo.Usuario
                WHERE UsuarioId = @Id;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapearUsuario(reader);
                    }
                }
            }

            return null;
        }

        public UsuarioDto ObtenerPorCorreo(string correo)
        {
            const string query = @"
                SELECT UsuarioId, Nombre, Correo, Clave, Programa, Rol, Telefono, FechaRegistro
                FROM dbo.Usuario
                WHERE Correo = @Correo;";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Correo", SqlDbType.NVarChar, 150).Value = correo;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapearUsuario(reader);
                    }
                }
            }

            return null;
        }

        public bool ExisteCorreo(string correo)
        {
            const string query = "SELECT COUNT(1) FROM dbo.Usuario WHERE Correo = @Correo;";
            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Correo", SqlDbType.NVarChar, 150).Value = correo.Trim();
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        public UsuarioDto Autenticar(string usuarioOCorreo, string clave)
        {
            const string query = @"
                SELECT UsuarioId, Nombre, Correo, Clave, Programa, Rol, Telefono, FechaRegistro
                FROM dbo.Usuario
                WHERE (Correo = @User OR CAST(UsuarioId AS NVARCHAR(50)) = @User)
                  AND (Clave = @Pass OR Telefono = @Pass);";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@User", SqlDbType.NVarChar, 150).Value = usuarioOCorreo.Trim();
                cmd.Parameters.Add("@Pass", SqlDbType.NVarChar, 100).Value = clave.Trim();
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapearUsuario(reader);
                    }
                }
            }

            return null;
        }

        public int Insertar(UsuarioDto u)
        {
            const string query = @"
                INSERT INTO dbo.Usuario (Nombre, Correo, Clave, Programa, Rol, Telefono)
                OUTPUT INSERTED.UsuarioId
                VALUES (@Nombre, @Correo, @Clave, @Programa, @Rol, @Telefono);";

            using (var con = ConexionDb.CrearConexion())
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Nombre", SqlDbType.NVarChar, 100).Value = u.Nombre.Trim();
                cmd.Parameters.Add("@Correo", SqlDbType.NVarChar, 150).Value = u.Correo.Trim();
                cmd.Parameters.Add("@Clave", SqlDbType.NVarChar, 100).Value = u.Clave.Trim();
                cmd.Parameters.Add("@Programa", SqlDbType.NVarChar, 100).Value = u.Programa.Trim();
                cmd.Parameters.Add("@Rol", SqlDbType.NVarChar, 30).Value = string.IsNullOrWhiteSpace(u.Rol) ? "Estudiante" : u.Rol.Trim();
                cmd.Parameters.Add("@Telefono", SqlDbType.NVarChar, 30).Value = (object)u.Telefono ?? DBNull.Value;

                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static UsuarioDto MapearUsuario(IDataRecord reader)
        {
            return new UsuarioDto
            {
                UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                Correo = reader.GetString(reader.GetOrdinal("Correo")),
                Clave = reader.GetString(reader.GetOrdinal("Clave")),
                Programa = reader.GetString(reader.GetOrdinal("Programa")),
                Rol = reader.GetString(reader.GetOrdinal("Rol")),
                Telefono = reader.IsDBNull(reader.GetOrdinal("Telefono")) ? "" : reader.GetString(reader.GetOrdinal("Telefono")),
                FechaRegistro = reader.GetDateTime(reader.GetOrdinal("FechaRegistro"))
            };
        }
    }
}
