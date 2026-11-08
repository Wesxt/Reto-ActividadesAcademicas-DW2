using System.Collections.Generic;
using UniCampus.Entities;

namespace WebApplication4.Views
{
    public interface IActividadesView
    {
        void MostrarActividades(IList<ActividadDto> actividades);
        void MostrarEstadisticas(EstadisticasDto estadisticas);
        void MostrarDetalleActividad(ActividadDto actividad);
        void OcultarDetalleActividad();
        void MostrarEstudiantesInscritos(IList<InscripcionDto> inscritos);
        void MostrarResenas(IList<ResenaDto> resenas);
        void CargarTiposActividad(IList<string> tipos);
        void CargarListaEstudiantes(IList<UsuarioDto> estudiantes);

        void MostrarMensajeExito(string mensaje);
        void MostrarMensajeError(string mensaje);
        void LimpiarFormulario();

        void ConfigurarPermisosPorRol(string rol);
        ActividadDto ObtenerDatosActividadFormulario();
        void CargarFormularioParaEdicion(ActividadDto actividad);

        void MostrarUsuariosAdmin(IList<UsuarioDto> usuarios);
        void MostrarTiposCatalogoAdmin(IList<TipoActividadDto> tipos);
    }
}
