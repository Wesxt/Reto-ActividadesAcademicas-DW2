using System;
using System.Collections.Generic;
using UniCampus.DAL;
using UniCampus.Entities;

namespace UniCampus.BLL
{
    public class InscripcionService
    {
        private readonly IInscripcionRepository _repo;

        public InscripcionService() : this(new InscripcionRepository())
        {
        }

        public InscripcionService(IInscripcionRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(repo));
        }

        public List<InscripcionDto> ListarPorActividad(int actividadId)
        {
            if (actividadId <= 0) return new List<InscripcionDto>();
            return _repo.ListarPorActividad(actividadId);
        }

        public ResultadoOperacion InscribirEstudiante(int actividadId, int usuarioId)
        {
            if (actividadId <= 0)
            {
                return ResultadoOperacion.Fallo("Debe seleccionar una actividad válida.");
            }

            if (usuarioId <= 0)
            {
                return ResultadoOperacion.Fallo("Debe seleccionar un estudiante válido.");
            }

            try
            {
                return _repo.Inscribir(actividadId, usuarioId);
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al procesar la inscripción: " + ex.Message);
            }
        }

        public ResultadoOperacion CancelarInscripcion(int inscripcionId)
        {
            if (inscripcionId <= 0)
            {
                return ResultadoOperacion.Fallo("Identificador de inscripción inválido.");
            }

            try
            {
                return _repo.CancelarInscripcion(inscripcionId);
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al cancelar la inscripción: " + ex.Message);
            }
        }
    }
}
