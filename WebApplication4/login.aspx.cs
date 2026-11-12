using System;
using System.Web.UI;
using UniCampus.Entities;
using WebApplication4.Presenters;
using WebApplication4.Views;

namespace WebApplication4
{
    public partial class login : Page, ILoginView
    {
        private LoginPresenter _presenter;

        protected void Page_Init(object sender, EventArgs e)
        {
            _presenter = new LoginPresenter(this);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                // Preserve password fields so Enter or validation doesn't clear them
                PreservarClaves();
            }
            else
            {
                if (Request.QueryString["modo"] == "registro")
                {
                    CambiarModo(esRegistro: true);
                }
            }
        }

        private void PreservarClaves()
        {
            if (!string.IsNullOrEmpty(txtClave.Text))
            {
                txtClave.Attributes["value"] = txtClave.Text;
            }
            if (!string.IsNullOrEmpty(txtRegClave.Text))
            {
                txtRegClave.Attributes["value"] = txtRegClave.Text;
            }
        }

        public string CorreoLogin => txtUsuario.Text.Trim();
        public string ClaveLogin => txtClave.Text.Trim();

        public UsuarioDto ObtenerDatosRegistro()
        {
            return new UsuarioDto
            {
                Nombre = txtRegNombre.Text.Trim(),
                Correo = txtRegCorreo.Text.Trim(),
                Clave = txtRegClave.Text.Trim(),
                Telefono = txtRegTelefono.Text.Trim(),
                Programa = ddlRegPrograma.SelectedValue,
                Rol = ddlRegRol.SelectedValue
            };
        }

        public void MostrarError(string mensaje)
        {
            lblMensaje.Text = Server.HtmlEncode(mensaje);
            lblMensaje.Visible = true;
            lblExito.Visible = false;

            // Retain password when displaying error
            PreservarClaves();
        }

        public void MostrarExito(string mensaje)
        {
            lblExito.Text = Server.HtmlEncode(mensaje);
            lblExito.Visible = true;
            lblMensaje.Visible = false;
        }

        public void AutenticacionExitosa(UsuarioDto usuario)
        {
            Session["UsuarioId"] = usuario.UsuarioId;
            Session["UsuarioLogueado"] = usuario.Correo;
            Session["UsuarioNombre"] = usuario.Nombre;
            Session["UsuarioCorreo"] = usuario.Correo;
            Session["UsuarioPrograma"] = usuario.Programa;
            Session["UsuarioRol"] = usuario.Rol;

            Response.Redirect("Actividades.aspx");
        }

        protected void btnIngresar_Click(object sender, EventArgs e)
        {
            PreservarClaves();
            _presenter.IniciarSesion();
        }

        protected void btnCrearCuenta_Click(object sender, EventArgs e)
        {
            PreservarClaves();
            _presenter.RegistrarCuenta();
        }

        protected void btnTabLogin_Click(object sender, EventArgs e)
        {
            CambiarModo(esRegistro: false);
        }

        protected void btnTabRegistro_Click(object sender, EventArgs e)
        {
            CambiarModo(esRegistro: true);
        }

        private void CambiarModo(bool esRegistro)
        {
            pnlLogin.Visible = !esRegistro;
            pnlRegistro.Visible = esRegistro;
            btnTabLogin.CssClass = esRegistro ? "tab-btn" : "tab-btn active";
            btnTabRegistro.CssClass = esRegistro ? "tab-btn active" : "tab-btn";
            lblMensaje.Visible = false;
            lblExito.Visible = false;

            PreservarClaves();
        }
    }
}
