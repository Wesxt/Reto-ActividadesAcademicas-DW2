using System;

namespace UniCampus.Entities
{
    public class ResenaDto
    {
        public int ResenaId { get; set; }
        public int ActividadId { get; set; }
        public int UsuarioId { get; set; }
        public string UsuarioNombre { get; set; }
        public string UsuarioPrograma { get; set; }
        public int Calificacion { get; set; }
        public string Comentario { get; set; }
        public DateTime FechaCreacion { get; set; }

        public string FechaFormateada => FechaCreacion.ToString("dd/MM/yyyy HH:mm");
        public string CalificacionTexto => $"{Calificacion}/5 ★";
    }
}
