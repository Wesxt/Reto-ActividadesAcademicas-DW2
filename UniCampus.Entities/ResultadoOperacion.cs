namespace UniCampus.Entities
{
    public class ResultadoOperacion
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; }
        public int? IdGenerado { get; set; }

        public static ResultadoOperacion Ok(string mensaje = "Operación realizada con éxito.", int? id = null)
        {
            return new ResultadoOperacion { Exito = true, Mensaje = mensaje, IdGenerado = id };
        }

        public static ResultadoOperacion Fallo(string mensaje)
        {
            return new ResultadoOperacion { Exito = false, Mensaje = mensaje };
        }
    }
}
