using System;
using System.Collections.Generic;
using UniCampus.DAL;
using UniCampus.Entities;

namespace UniCampus.BLL
{
    public class ActividadService
    {
        private readonly IActividadRepository _repo;

        public ActividadService() : this(new ActividadRepository())
        {
        }

        public ActividadService(IActividadRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(repo));
        }

        public List<ActividadDto> ListarActividades(string criterio = null, string estado = null, string tipo = null, DateTime? fecha = null)
        {
            return _repo.ListarConFiltro(criterio, estado, tipo, fecha);
        }

        public ActividadDto ObtenerPorId(int id)
        {
            if (id <= 0) return null;
            return _repo.ObtenerPorId(id);
        }

        public ResultadoOperacion GuardarActividad(ActividadDto act)
        {
            if (act == null)
            {
                return ResultadoOperacion.Fallo("Los datos de la actividad no pueden ser nulos.");
            }

            if (string.IsNullOrWhiteSpace(act.Titulo))
            {
                return ResultadoOperacion.Fallo("El título de la actividad es obligatorio.");
            }

            if (act.Titulo.Trim().Length > 120)
            {
                return ResultadoOperacion.Fallo("El título no puede superar los 120 caracteres.");
            }

            if (string.IsNullOrWhiteSpace(act.Tipo))
            {
                return ResultadoOperacion.Fallo("Debe seleccionar un tipo de actividad válido.");
            }

            if (act.FechaInicio == DateTime.MinValue)
            {
                return ResultadoOperacion.Fallo("Debe especificar una fecha de inicio válida.");
            }

            if (act.FechaFin != DateTime.MinValue && act.FechaFin < act.FechaInicio)
            {
                return ResultadoOperacion.Fallo("La fecha de finalización no puede ser anterior a la fecha de inicio.");
            }

            if (act.Cupos < 0)
            {
                return ResultadoOperacion.Fallo("El número de cupos disponibles no puede ser negativo.");
            }

            if (string.IsNullOrWhiteSpace(act.Lugar))
            {
                return ResultadoOperacion.Fallo("Debe indicar el lugar o espacio asignado para la actividad.");
            }

            if (string.IsNullOrWhiteSpace(act.Estado))
            {
                act.Estado = "Activa";
            }

            try
            {
                if (act.ActividadId > 0)
                {
                    bool ok = _repo.Actualizar(act);
                    return ok 
                        ? ResultadoOperacion.Ok("Actividad actualizada exitosamente.", act.ActividadId)
                        : ResultadoOperacion.Fallo("No se pudo actualizar la actividad.");
                }
                else
                {
                    int nuevoId = _repo.Insertar(act);
                    return ResultadoOperacion.Ok("Actividad registrada exitosamente.", nuevoId);
                }
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error en capa de datos: " + ex.Message);
            }
        }

        public ResultadoOperacion EliminarActividad(int id)
        {
            if (id <= 0)
            {
                return ResultadoOperacion.Fallo("Identificador de actividad inválido.");
            }

            try
            {
                bool ok = _repo.Eliminar(id);
                return ok 
                    ? ResultadoOperacion.Ok("Actividad eliminada exitosamente.")
                    : ResultadoOperacion.Fallo("No se encontró la actividad a eliminar.");
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("No se pudo eliminar la actividad: " + ex.Message);
            }
        }

        public EstadisticasDto ObtenerDashboard()
        {
            return _repo.ObtenerEstadisticas();
        }
    }
}
