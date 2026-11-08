using System;
using System.Collections.Generic;
using UniCampus.DAL;
using UniCampus.Entities;

namespace UniCampus.BLL
{
    public class ResenaService
    {
        private readonly IResenaRepository _repo;

        public ResenaService() : this(new ResenaRepository())
        {
        }

        public ResenaService(IResenaRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(repo));
        }

        public List<ResenaDto> ListarPorActividad(int actividadId)
        {
            if (actividadId <= 0) return new List<ResenaDto>();
            return _repo.ListarPorActividad(actividadId);
        }

        public ResultadoOperacion AgregarResena(ResenaDto resena)
        {
            if (resena == null)
            {
                return ResultadoOperacion.Fallo("Los datos de la reseña no son válidos.");
            }

            if (resena.ActividadId <= 0)
            {
                return ResultadoOperacion.Fallo("Debe seleccionar una actividad válida.");
            }

            if (resena.UsuarioId <= 0)
            {
                return ResultadoOperacion.Fallo("Debe iniciar sesión con un usuario válido para publicar una reseña.");
            }

            if (resena.Calificacion < 1 || resena.Calificacion > 5)
            {
                return ResultadoOperacion.Fallo("La calificación debe ser un valor entero entre 1 y 5.");
            }

            if (string.IsNullOrWhiteSpace(resena.Comentario))
            {
                return ResultadoOperacion.Fallo("El comentario de la reseña no puede estar vacío.");
            }

            if (resena.Comentario.Trim().Length > 1000)
            {
                return ResultadoOperacion.Fallo("El comentario no puede exceder los 1000 caracteres.");
            }

            try
            {
                if (_repo.ExisteResena(resena.ActividadId, resena.UsuarioId))
                {
                    return ResultadoOperacion.Fallo("Ya has publicado una reseña para esta actividad.");
                }

                resena.Comentario = resena.Comentario.Trim();
                int id = _repo.Insertar(resena);
                return ResultadoOperacion.Ok("Reseña publicada exitosamente.", id);
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al guardar la reseña: " + ex.Message);
            }
        }

        public ResultadoOperacion EliminarResena(int resenaId)
        {
            if (resenaId <= 0)
            {
                return ResultadoOperacion.Fallo("Identificador de reseña inválido.");
            }

            try
            {
                bool ok = _repo.Eliminar(resenaId);
                return ok
                    ? ResultadoOperacion.Ok("Reseña eliminada.")
                    : ResultadoOperacion.Fallo("No se encontró la reseña.");
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al eliminar la reseña: " + ex.Message);
            }
        }
    }
}
