using UniCampus.Entities;

namespace WebApplication4.Views
{
    public interface ILoginView
    {
        string CorreoLogin { get; }
        string ClaveLogin { get; }

        UsuarioDto ObtenerDatosRegistro();
        void MostrarError(string mensaje);
        void MostrarExito(string mensaje);
        void AutenticacionExitosa(UsuarioDto usuario);
    }
}
