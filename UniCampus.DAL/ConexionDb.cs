using System;
using System.Configuration;
using System.Data.SqlClient;

namespace UniCampus.DAL
{
    public static class ConexionDb
    {
        private static string _cadenaSobrescrita;

        public static void ConfigurarCadena(string connectionString)
        {
            _cadenaSobrescrita = connectionString;
        }

        public static string ObtenerCadena()
        {
            if (!string.IsNullOrWhiteSpace(_cadenaSobrescrita))
            {
                return _cadenaSobrescrita;
            }

            var connSetting = ConfigurationManager.ConnectionStrings["UniCampusDb"];
            if (connSetting != null && !string.IsNullOrWhiteSpace(connSetting.ConnectionString))
            {
                return connSetting.ConnectionString;
            }

            throw new InvalidOperationException("No se encontró la cadena de conexión 'UniCampusDb' en Web.config.");
        }

        public static SqlConnection CrearConexion()
        {
            return new SqlConnection(ObtenerCadena());
        }
    }
}
