using System.Collections.Generic;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public interface IUsuarioRepository
    {
        List<UsuarioDto> ListarEstudiantes();
        List<UsuarioDto> ListarTodos();
        UsuarioDto ObtenerPorId(int id);
        UsuarioDto ObtenerPorCorreo(string correo);
        bool ExisteCorreo(string correo);
        UsuarioDto Autenticar(string usuarioOCorreo, string clave);
        int Insertar(UsuarioDto usuario);
        bool ActualizarRol(int usuarioId, string nuevoRol);
        bool EliminarUsuario(int usuarioId);
    }
}
