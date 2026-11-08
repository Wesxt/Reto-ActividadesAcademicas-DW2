using System;
using System.Collections.Generic;
using UniCampus.DAL;
using UniCampus.Entities;

namespace UniCampus.BLL
{
    public class TipoActividadService
    {
        private readonly ITipoActividadRepository _repo;

        public TipoActividadService() : this(new TipoActividadRepository())
        {
        }

        public TipoActividadService(ITipoActividadRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(repo));
        }

        public List<TipoActividadDto> ListarTodos()
        {
            return _repo.ListarTodos();
        }

        public ResultadoOperacion Crear(TipoActividadDto tipo)
        {
            if (tipo == null)
            {
                return ResultadoOperacion.Fallo("Los datos del tipo de actividad no pueden ser nulos.");
            }

            if (string.IsNullOrWhiteSpace(tipo.Nombre))
            {
                return ResultadoOperacion.Fallo("El nombre de la categoría o tipo de actividad es obligatorio.");
            }

            string nombreLimpio = tipo.Nombre.Trim();

            if (nombreLimpio.Length < 3 || nombreLimpio.Length > 50)
            {
                return ResultadoOperacion.Fallo("El nombre del tipo debe tener entre 3 y 50 caracteres.");
            }

            try
            {
                if (_repo.Existe(nombreLimpio))
                {
                    return ResultadoOperacion.Fallo($"Ya existe un tipo de actividad denominado '{nombreLimpio}'.");
                }

                tipo.Nombre = nombreLimpio;
                tipo.Descripcion = tipo.Descripcion?.Trim() ?? string.Empty;

                int nuevoId = _repo.Insertar(tipo);
                return ResultadoOperacion.Ok($"Tipo de actividad '{nombreLimpio}' registrado exitosamente.", nuevoId);
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al registrar en base de datos: " + ex.Message);
            }
        }

        public ResultadoOperacion Eliminar(int tipoId)
        {
            if (tipoId <= 0)
            {
                return ResultadoOperacion.Fallo("Identificador de categoría no válido.");
            }

            try
            {
                bool borrado = _repo.Eliminar(tipoId);
                return borrado
                    ? ResultadoOperacion.Ok("Tipo de actividad eliminado exitosamente.")
                    : ResultadoOperacion.Fallo("No se encontró el tipo de actividad o no se pudo eliminar.");
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al eliminar categoría: " + ex.Message);
            }
        }
    }
}
