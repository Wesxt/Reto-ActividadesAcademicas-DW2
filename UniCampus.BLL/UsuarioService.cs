using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UniCampus.DAL;
using UniCampus.Entities;

namespace UniCampus.BLL
{
    public class UsuarioService
    {
        private readonly IUsuarioRepository _repo;

        public UsuarioService() : this(new UsuarioRepository())
        {
        }

        public UsuarioService(IUsuarioRepository repo)
        {
            _repo = repo ?? throw new ArgumentNullException(nameof(repo));
        }

        public List<UsuarioDto> ListarEstudiantes()
        {
            return _repo.ListarEstudiantes();
        }

        public UsuarioDto ObtenerPorId(int id)
        {
            if (id <= 0) return null;
            return _repo.ObtenerPorId(id);
        }

        public ResultadoOperacion Autenticar(string usuarioOCorreo, string clave, out UsuarioDto usuarioAutenticado)
        {
            usuarioAutenticado = null;

            if (string.IsNullOrWhiteSpace(usuarioOCorreo))
            {
                return ResultadoOperacion.Fallo("Debe ingresar su correo o ID de usuario.");
            }

            if (string.IsNullOrWhiteSpace(clave))
            {
                return ResultadoOperacion.Fallo("Debe ingresar su contraseña.");
            }

            try
            {
                var u = _repo.Autenticar(usuarioOCorreo, clave);
                if (u == null)
                {
                    return ResultadoOperacion.Fallo("Credenciales incorrectas o cuenta no registrada.");
                }

                usuarioAutenticado = u;
                return ResultadoOperacion.Ok("Inicio de sesión exitoso.", u.UsuarioId);
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error de conexión con la base de datos: " + ex.Message);
            }
        }

        public ResultadoOperacion RegistrarUsuario(UsuarioDto nuevo)
        {
            if (nuevo == null)
            {
                return ResultadoOperacion.Fallo("Los datos del usuario no pueden ser nulos.");
            }

            if (string.IsNullOrWhiteSpace(nuevo.Nombre))
            {
                return ResultadoOperacion.Fallo("El nombre completo es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(nuevo.Correo) || !Regex.IsMatch(nuevo.Correo.Trim(), @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                return ResultadoOperacion.Fallo("Debe ingresar un correo electrónico con formato válido.");
            }

            if (string.IsNullOrWhiteSpace(nuevo.Clave) || nuevo.Clave.Trim().Length < 4)
            {
                return ResultadoOperacion.Fallo("La contraseña debe tener al menos 4 caracteres.");
            }

            if (string.IsNullOrWhiteSpace(nuevo.Programa))
            {
                return ResultadoOperacion.Fallo("Debe seleccionar su programa académico.");
            }

            try
            {
                if (_repo.ExisteCorreo(nuevo.Correo))
                {
                    return ResultadoOperacion.Fallo("Este correo electrónico ya se encuentra registrado.");
                }

                int idGenerado = _repo.Insertar(nuevo);
                return ResultadoOperacion.Ok("Cuenta creada exitosamente.", idGenerado);
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al registrar el usuario en base de datos: " + ex.Message);
            }
        }

        public List<UsuarioDto> ListarTodosUsuarios()
        {
            return _repo.ListarTodos();
        }

        public ResultadoOperacion CambiarRol(int usuarioId, string nuevoRol, int adminIdSolicitante)
        {
            if (usuarioId <= 0)
            {
                return ResultadoOperacion.Fallo("Identificador de usuario no válido.");
            }

            if (string.IsNullOrWhiteSpace(nuevoRol))
            {
                return ResultadoOperacion.Fallo("El rol asignado no puede estar vacío.");
            }

            nuevoRol = nuevoRol.Trim();
            if (nuevoRol != "Estudiante" && nuevoRol != "Docente" && nuevoRol != "Administrador")
            {
                return ResultadoOperacion.Fallo("El rol especificado no es reconocido por el sistema (Estudiante, Docente, Administrador).");
            }

            if (usuarioId == adminIdSolicitante && nuevoRol != "Administrador")
            {
                return ResultadoOperacion.Fallo("Un administrador no puede revocar su propio rol de administrador para evitar bloqueos del sistema.");
            }

            try
            {
                bool modificado = _repo.ActualizarRol(usuarioId, nuevoRol);
                return modificado
                    ? ResultadoOperacion.Ok($"Rol actualizado correctamente a '{nuevoRol}'.")
                    : ResultadoOperacion.Fallo("No se encontró el usuario solicitado para actualizar.");
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al actualizar rol en base de datos: " + ex.Message);
            }
        }

        public ResultadoOperacion EliminarUsuario(int usuarioId, int adminIdSolicitante)
        {
            if (usuarioId <= 0)
            {
                return ResultadoOperacion.Fallo("Identificador de usuario no válido.");
            }

            if (usuarioId == adminIdSolicitante)
            {
                return ResultadoOperacion.Fallo("No puede eliminar su propia cuenta de administrador en sesión activa.");
            }

            try
            {
                bool eliminado = _repo.EliminarUsuario(usuarioId);
                return eliminado
                    ? ResultadoOperacion.Ok("Usuario eliminado exitosamente del sistema.")
                    : ResultadoOperacion.Fallo("No se pudo eliminar el usuario especificado.");
            }
            catch (Exception ex)
            {
                return ResultadoOperacion.Fallo("Error al eliminar usuario en base de datos: " + ex.Message);
            }
        }
    }
}
