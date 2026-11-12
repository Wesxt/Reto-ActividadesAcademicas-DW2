using System;
using System.Collections.Generic;
using System.Linq;
using UniCampus.BLL;
using UniCampus.Entities;
using WebApplication4.Views;

namespace WebApplication4.Presenters
{
    public class ActividadesPresenter
    {
        private readonly IActividadesView _view;
        private readonly ActividadService _actividadService;
        private readonly InscripcionService _inscripcionService;
        private readonly UsuarioService _usuarioService;
        private readonly ResenaService _resenaService;
        private readonly TipoActividadService _tipoActividadService;

        public ActividadesPresenter(IActividadesView view)
            : this(view, new ActividadService(), new InscripcionService(), new UsuarioService(), new ResenaService(), new TipoActividadService())
        {
        }

        public ActividadesPresenter(
            IActividadesView view,
            ActividadService actividadService,
            InscripcionService inscripcionService,
            UsuarioService usuarioService,
            ResenaService resenaService,
            TipoActividadService tipoActividadService)
        {
            _view = view ?? throw new ArgumentNullException(nameof(view));
            _actividadService = actividadService ?? throw new ArgumentNullException(nameof(actividadService));
            _inscripcionService = inscripcionService ?? throw new ArgumentNullException(nameof(inscripcionService));
            _usuarioService = usuarioService ?? throw new ArgumentNullException(nameof(usuarioService));
            _resenaService = resenaService ?? throw new ArgumentNullException(nameof(resenaService));
            _tipoActividadService = tipoActividadService ?? throw new ArgumentNullException(nameof(tipoActividadService));
        }

        public void Inicializar()
        {
            RecargarTiposActividad();

            try
            {
                var estudiantes = _usuarioService.ListarEstudiantes();
                _view.CargarListaEstudiantes(estudiantes);

                ActualizarDashboard();
                CargarActividades();
            }
            catch (Exception ex)
            {
                _view.MostrarEstadisticas(new EstadisticasDto());
                _view.MostrarActividades(new List<ActividadDto>());
                _view.OcultarDetalleActividad();
                _view.MostrarMensajeError("No fue posible conectar con la base de datos: " + ex.Message);
            }
        }

        public void RecargarTiposActividad()
        {
            try
            {
                var tiposDb = _tipoActividadService.ListarTodos();
                if (tiposDb != null && tiposDb.Count > 0)
                {
                    _view.CargarTiposActividad(tiposDb.Select(t => t.Nombre).ToList());
                }
                else
                {
                    _view.CargarTiposActividad(new List<string> { "Taller", "Conferencia", "Seminario", "Simposio", "Webinar" });
                }
            }
            catch
            {
                _view.CargarTiposActividad(new List<string> { "Taller", "Conferencia", "Seminario", "Simposio", "Webinar" });
            }
        }

        public void CargarActividades(string criterio = null, string estado = null, string tipo = null, DateTime? fecha = null)
        {
            try
            {
                var actividades = _actividadService.ListarActividades(criterio, estado, tipo, fecha);
                _view.MostrarActividades(actividades);

                if (actividades != null && actividades.Count > 0)
                {
                    SeleccionarActividad(actividades.First().ActividadId);
                }
                else
                {
                    _view.OcultarDetalleActividad();
                }
            }
            catch (Exception ex)
            {
                _view.MostrarActividades(new List<ActividadDto>());
                _view.OcultarDetalleActividad();
                _view.MostrarMensajeError("Error al consultar actividades: " + ex.Message);
            }
        }

        public void SeleccionarActividad(int actividadId)
        {
            try
            {
                var actividad = _actividadService.ObtenerPorId(actividadId);
                if (actividad != null)
                {
                    _view.MostrarDetalleActividad(actividad);
                    var inscritos = _inscripcionService.ListarPorActividad(actividadId);
                    _view.MostrarEstudiantesInscritos(inscritos);
                    var resenas = _resenaService.ListarPorActividad(actividadId);
                    _view.MostrarResenas(resenas);
                }
                else
                {
                    _view.OcultarDetalleActividad();
                }
            }
            catch (Exception ex)
            {
                _view.OcultarDetalleActividad();
                _view.MostrarMensajeError("Error al consultar detalles: " + ex.Message);
            }
        }

        public void PrepararEdicion(int actividadId)
        {
            try
            {
                var actividad = _actividadService.ObtenerPorId(actividadId);
                if (actividad != null)
                {
                    _view.CargarFormularioParaEdicion(actividad);
                }
                else
                {
                    _view.MostrarMensajeError("No se encontró la actividad solicitada.");
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al cargar actividad para edición: " + ex.Message);
            }
        }

        public void GuardarActividad()
        {
            try
            {
                var actividad = _view.ObtenerDatosActividadFormulario();
                var resultado = _actividadService.GuardarActividad(actividad);

                if (resultado.Exito)
                {
                    _view.MostrarMensajeExito(resultado.Mensaje);
                    _view.LimpiarFormulario();
                    ActualizarDashboard();
                    CargarActividades();

                    int idSeleccionar = resultado.IdGenerado ?? actividad.ActividadId;
                    if (idSeleccionar > 0)
                    {
                        SeleccionarActividad(idSeleccionar);
                    }
                }
                else
                {
                    _view.MostrarMensajeError(resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al guardar la actividad: " + ex.Message);
            }
        }

        public void EliminarActividad(int actividadId)
        {
            try
            {
                var resultado = _actividadService.EliminarActividad(actividadId);
                if (resultado.Exito)
                {
                    _view.MostrarMensajeExito(resultado.Mensaje);
                    ActualizarDashboard();
                    CargarActividades();
                }
                else
                {
                    _view.MostrarMensajeError(resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al eliminar la actividad: " + ex.Message);
            }
        }

        public void InscribirEstudiante(int actividadId, int usuarioId)
        {
            try
            {
                var resultado = _inscripcionService.InscribirEstudiante(actividadId, usuarioId);
                if (resultado.Exito)
                {
                    _view.MostrarMensajeExito(resultado.Mensaje);
                    ActualizarDashboard();
                    CargarActividades();
                    SeleccionarActividad(actividadId);
                }
                else
                {
                    _view.MostrarMensajeError(resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al procesar inscripción: " + ex.Message);
            }
        }

        public void CancelarInscripcion(int inscripcionId, int actividadId, int usuarioIdSolicitante = 0, bool puedeGestionar = true)
        {
            try
            {
                if (!puedeGestionar)
                {
                    var inscritos = _inscripcionService.ListarPorActividad(actividadId);
                    var mia = inscritos?.FirstOrDefault(i => i.InscripcionId == inscripcionId);
                    if (mia == null || mia.UsuarioId != usuarioIdSolicitante)
                    {
                        _view.MostrarMensajeError("Acceso denegado: sólo puedes cancelar tu propia inscripción.");
                        return;
                    }
                }

                var resultado = _inscripcionService.CancelarInscripcion(inscripcionId);
                if (resultado.Exito)
                {
                    _view.MostrarMensajeExito(resultado.Mensaje);
                    ActualizarDashboard();
                    CargarActividades();
                    SeleccionarActividad(actividadId);
                }
                else
                {
                    _view.MostrarMensajeError(resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al cancelar inscripción: " + ex.Message);
            }
        }

        public void PublicarResena(int actividadId, int usuarioId, int calificacion, string comentario)
        {
            try
            {
                var nueva = new ResenaDto
                {
                    ActividadId = actividadId,
                    UsuarioId = usuarioId,
                    Calificacion = calificacion,
                    Comentario = comentario
                };

                var resultado = _resenaService.AgregarResena(nueva);
                if (resultado.Exito)
                {
                    _view.MostrarMensajeExito(resultado.Mensaje);
                    SeleccionarActividad(actividadId);
                }
                else
                {
                    _view.MostrarMensajeError(resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al publicar la reseña: " + ex.Message);
            }
        }

        public void EliminarResena(int resenaId, int actividadId, int usuarioIdSolicitante = 0, bool esAdmin = false)
        {
            try
            {
                if (!esAdmin)
                {
                    var resenas = _resenaService.ListarPorActividad(actividadId);
                    var mia = resenas?.FirstOrDefault(r => r.ResenaId == resenaId);
                    if (mia == null || mia.UsuarioId != usuarioIdSolicitante)
                    {
                        _view.MostrarMensajeError("Acceso denegado: sólo puedes eliminar tus propias opiniones.");
                        return;
                    }
                }

                var resultado = _resenaService.EliminarResena(resenaId);
                if (resultado.Exito)
                {
                    _view.MostrarMensajeExito(resultado.Mensaje);
                    SeleccionarActividad(actividadId);
                }
                else
                {
                    _view.MostrarMensajeError(resultado.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al eliminar la reseña: " + ex.Message);
            }
        }

        private void ActualizarDashboard()
        {
            var stats = _actividadService.ObtenerDashboard();
            _view.MostrarEstadisticas(stats);
        }

        #region Capacidades Exclusivas de Administrador

        public void CargarGestionAdmin()
        {
            try
            {
                var usuarios = _usuarioService.ListarTodosUsuarios();
                _view.MostrarUsuariosAdmin(usuarios);

                var tipos = _tipoActividadService.ListarTodos();
                _view.MostrarTiposCatalogoAdmin(tipos);
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al cargar datos administrativos: " + ex.Message);
            }
        }

        public void CambiarRolUsuario(int usuarioId, string nuevoRol, int adminIdSolicitante)
        {
            try
            {
                var res = _usuarioService.CambiarRol(usuarioId, nuevoRol, adminIdSolicitante);
                if (res.Exito)
                {
                    _view.MostrarMensajeExito(res.Mensaje);
                    CargarGestionAdmin();
                    // Refrescar lista de estudiantes disponibles para inscribir
                    _view.CargarListaEstudiantes(_usuarioService.ListarEstudiantes());
                }
                else
                {
                    _view.MostrarMensajeError(res.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al modificar rol: " + ex.Message);
            }
        }

        public void EliminarUsuario(int usuarioId, int adminIdSolicitante)
        {
            try
            {
                var res = _usuarioService.EliminarUsuario(usuarioId, adminIdSolicitante);
                if (res.Exito)
                {
                    _view.MostrarMensajeExito(res.Mensaje);
                    CargarGestionAdmin();
                    _view.CargarListaEstudiantes(_usuarioService.ListarEstudiantes());
                    ActualizarDashboard();
                    CargarActividades();
                }
                else
                {
                    _view.MostrarMensajeError(res.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al eliminar usuario: " + ex.Message);
            }
        }

        public void CrearTipoActividad(string nombre, string descripcion)
        {
            try
            {
                var res = _tipoActividadService.Crear(new TipoActividadDto
                {
                    Nombre = nombre,
                    Descripcion = descripcion
                });

                if (res.Exito)
                {
                    _view.MostrarMensajeExito(res.Mensaje);
                    RecargarTiposActividad();
                    CargarGestionAdmin();
                }
                else
                {
                    _view.MostrarMensajeError(res.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al registrar categoría: " + ex.Message);
            }
        }

        public void EliminarTipoActividad(int tipoId)
        {
            try
            {
                var res = _tipoActividadService.Eliminar(tipoId);
                if (res.Exito)
                {
                    _view.MostrarMensajeExito(res.Mensaje);
                    RecargarTiposActividad();
                    CargarGestionAdmin();
                }
                else
                {
                    _view.MostrarMensajeError(res.Mensaje);
                }
            }
            catch (Exception ex)
            {
                _view.MostrarMensajeError("Error al eliminar categoría: " + ex.Message);
            }
        }

        #endregion
    }
}
