using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4
{
    public partial class _Default : Page
    {
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (!IsPostBack)
        //    {
        //        // Poblar listas
        //        ddlPrograma.Items.Clear();
        //        ddlPrograma.Items.Add(new ListItem("-- Seleccione --", ""));
        //        ddlPrograma.Items.Add(new ListItem("Ingeniería", "Ingenieria"));
        //        ddlPrograma.Items.Add(new ListItem("Ciencias", "Ciencias"));
        //        ddlPrograma.Items.Add(new ListItem("Artes", "Artes"));

        //        ddlSemestre.Items.Clear();
        //        ddlSemestre.Items.Add(new ListItem("-- Seleccione --", ""));
        //        for (int i = 1; i <= 10; i++)
        //        {
        //            ddlSemestre.Items.Add(new ListItem(i.ToString(), i.ToString()));
        //        }

        //        rblParticipacion.Items.Clear();
        //        rblParticipacion.Items.Add(new ListItem("Ponencia", "Ponencia"));
        //        rblParticipacion.Items.Add(new ListItem("Asistente", "Asistente"));
        //        rblParticipacion.Items.Add(new ListItem("Taller", "Taller"));

        //        ddlJornada.Items.Clear();
        //        ddlJornada.Items.Add(new ListItem("-- Seleccione --", ""));
        //        ddlJornada.Items.Add(new ListItem("Mañana", "Mañana"));
        //        ddlJornada.Items.Add(new ListItem("Tarde", "Tarde"));
        //        ddlJornada.Items.Add(new ListItem("Noche", "Noche"));

        //        cblTemas.Items.Clear();
        //        cblTemas.Items.Add(new ListItem("Sistemas Distribuidos", "SD"));
        //        cblTemas.Items.Add(new ListItem("Inteligencia Artificial", "IA"));
        //        cblTemas.Items.Add(new ListItem("Seguridad", "Seguridad"));
        //        cblTemas.Items.Add(new ListItem("Interacción Humano-Computadora", "HCI"));
        //    }
        //}

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                Response.Redirect("Actividades.aspx");
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            // Mostrar u ocultar panel de validación según el estado de la página
            pnlValidation.Visible = !Page.IsValid;

            if (Page.IsValid)
            {
                string nombres = txtNombres.Text.Trim();
                string apellidos = txtApellidos.Text.Trim();
                pnlFormulario.Visible = false;
                pnlValidation.Visible = false;
                pnlConfirmacion.Visible = true;
                lblConfirmacion.Text = "Hola, " + nombres + " " + apellidos + ". Tu participación fue registrada.";
                lblCodigoRegistro.Text = "EVT-" + DateTime.Now.Year + "-" + DateTime.Now.ToString("MMddHHmm");
                lblProgramaRegistro.Text = ddlPrograma.SelectedItem.Text;
                lblJornadaRegistro.Text = ddlJornada.SelectedItem.Text;
                lblMensaje.Text = "";
            }
            else
            {
                lblMensaje.Text = "Corrija los errores del formulario.";
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtNombres.Text = "";
            txtApellidos.Text = "";
            txtCorreo.Text = "";
            txtTelefono.Text = "";
            ddlPrograma.SelectedIndex = 0;
            ddlSemestre.SelectedIndex = 0;
            rblParticipacion.ClearSelection();
            ddlJornada.SelectedIndex = 0;
            foreach (ListItem it in cblTemas.Items) it.Selected = false;
            txtComentarios.Text = "";
            chkAcepta.Checked = false;
            lblMensaje.Text = "";
            pnlValidation.Visible = false;
            pnlConfirmacion.Visible = false;
            pnlFormulario.Visible = true;
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Redirigir a la misma página o a otra ruta según necesidad
            Response.Redirect(Request.Url.AbsolutePath);
        }

        protected void btnNuevoRegistro_Click(object sender, EventArgs e)
        {
            btnLimpiar_Click(sender, e);
        }

        protected void cvTemas_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = cblTemas.Items.Cast<ListItem>().Any(i => i.Selected);
        }

        protected void cvAcepta_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkAcepta.Checked;
        }

        protected void cvNombres_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrWhiteSpace(args.Value);
        }

        protected void cvApellidos_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrWhiteSpace(args.Value);
        }
    }
}