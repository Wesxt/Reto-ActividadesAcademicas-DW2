using System;

namespace UniCampus.Entities
{
    public class ActividadDto
    {
        public int ActividadId { get; set; }
        public string Titulo { get; set; }
        public string Descripcion { get; set; }
        public string Tipo { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }
        public string HoraInicio { get; set; }
        public string HoraFin { get; set; }
        public string Modalidad { get; set; }
        public string Lugar { get; set; }
        public int Cupos { get; set; }
        public string Estado { get; set; }
        public DateTime FechaCreacion { get; set; }

        public string FechasFormateadas
        {
            get
            {
                if (FechaInicio == FechaFin || FechaFin == DateTime.MinValue)
                {
                    return FechaInicio.ToString("dd/MM/yyyy");
                }
                return $"{FechaInicio:dd/MM/yyyy} - {FechaFin:dd/MM/yyyy}";
            }
        }

        public string HorarioFormateado
        {
            get
            {
                return $"{HoraInicio} - {HoraFin}";
            }
        }
    }
}
