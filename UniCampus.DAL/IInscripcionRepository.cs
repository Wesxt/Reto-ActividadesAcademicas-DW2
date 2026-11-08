using System.Collections.Generic;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public interface IInscripcionRepository
    {
        List<InscripcionDto> ListarPorActividad(int actividadId);
        bool EstaInscrito(int actividadId, int usuarioId);
        ResultadoOperacion Inscribir(int actividadId, int usuarioId);
        ResultadoOperacion CancelarInscripcion(int inscripcionId);
    }
}
