using System;
using UniCampus.BLL;
using UniCampus.Entities;
using WebApplication4.Views;

namespace WebApplication4.Presenters
{
    public class LoginPresenter
    {
        private readonly ILoginView _view;
        private readonly UsuarioService _usuarioService;

        public LoginPresenter(ILoginView view) : this(view, new UsuarioService())
        {
        }

        public LoginPresenter(ILoginView view, UsuarioService usuarioService)
        {
            _view = view ?? throw new ArgumentNullException(nameof(view));
            _usuarioService = usuarioService ?? throw new ArgumentNullException(nameof(usuarioService));
        }

        public void IniciarSesion()
        {
            var resultado = _usuarioService.Autenticar(_view.CorreoLogin, _view.ClaveLogin, out UsuarioDto usuario);
            if (resultado.Exito && usuario != null)
            {
                _view.AutenticacionExitosa(usuario);
            }
            else
            {
                _view.MostrarError(resultado.Mensaje);
            }
        }

        public void RegistrarCuenta()
        {
            var nuevo = _view.ObtenerDatosRegistro();
            var resultado = _usuarioService.RegistrarUsuario(nuevo);

            if (resultado.Exito && resultado.IdGenerado.HasValue)
            {
                nuevo.UsuarioId = resultado.IdGenerado.Value;
                _view.AutenticacionExitosa(nuevo);
            }
            else
            {
                _view.MostrarError(resultado.Mensaje);
            }
        }
    }
}
