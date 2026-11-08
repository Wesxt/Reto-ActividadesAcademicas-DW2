using System;

namespace UniCampus.Entities
{
    public class InscripcionDto
    {
        public int InscripcionId { get; set; }
        public int ActividadId { get; set; }
        public string TituloActividad { get; set; }
        public int UsuarioId { get; set; }
        public string EstudianteNombre { get; set; }
        public string EstudianteCorreo { get; set; }
        public string EstudiantePrograma { get; set; }
        public DateTime FechaInscripcion { get; set; }
        public string Estado { get; set; }

        public string FechaInscripcionFormateada => FechaInscripcion.ToString("dd/MM/yyyy");
    }
}
