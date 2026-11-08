using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4
{
    public partial class FormularioWeb : Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCatalogos();
            }
        }

        private void CargarCatalogos()
        {
            // 1. Programa
            CargarCombo("SELECT id_programa, nombre FROM Programa", ddlPrograma, "nombre", "id_programa", "-- Seleccione Programa --");

            // 2. Semestre
            CargarCombo("SELECT id_semestre, descripcion FROM Semestre ORDER BY CAST(id_semestre AS INT)", ddlSemestre, "descripcion", "id_semestre", "-- Seleccione Semestre --");

            // 3. Jornada
            CargarCombo("SELECT id_jornada, description FROM Jornada", ddlJornada, "description", "id_jornada", "-- Seleccione Jornada --");

            // 4. Tipo de Participación (RadioButtonList)
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT id_participacion, description FROM Tipo_participacion", con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rblParticipacion.DataSource = dt;
                    rblParticipacion.DataTextField = "description";
                    rblParticipacion.DataValueField = "id_participacion";
                    rblParticipacion.DataBind();
                }
            }

            // 5. Temas (CheckBoxList)
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT id_tema, description FROM Tema", con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    cblTemas.DataSource = dt;
                    cblTemas.DataTextField = "description";
                    cblTemas.DataValueField = "id_tema";
                    cblTemas.DataBind();
                }
            }
        }

        private void CargarCombo(string query, DropDownList ddl, string textField, string valueField, string defaultText)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddl.DataSource = dt;
                    ddl.DataTextField = textField;
                    ddl.DataValueField = valueField;
                    ddl.DataBind();
                    ddl.Items.Insert(0, new ListItem(defaultText, ""));
                }
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            pnlValidation.Visible = !Page.IsValid;

            if (!Page.IsValid)
            {
                return;
            }

            // Obtener el primer tema seleccionado
            string temaSeleccionado = cblTemas.Items.Cast<ListItem>().FirstOrDefault(i => i.Selected)?.Value;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Verificar si el estudiante existe por correo o insertar nuevo (id_estudiante es IDENTITY)
                        string sqlEstudiante = @"
                            DECLARE @EstudianteId BIGINT;
                            SELECT @EstudianteId = id_estudiante FROM Estudiante WHERE correo = @cor;

                            IF @EstudianteId IS NOT NULL
                            BEGIN
                                UPDATE Estudiante 
                                SET nombre = @nom, apellidos = @ape, telefono = @tel 
                                WHERE id_estudiante = @EstudianteId;
                            END
                            ELSE
                            BEGIN
                                INSERT INTO Estudiante (nombre, apellidos, correo, telefono)
                                VALUES (@nom, @ape, @cor, @tel);
                                SET @EstudianteId = SCOPE_IDENTITY();
                            END

                            SELECT @EstudianteId;";

                        long idEstudianteGenerado;
                        using (SqlCommand cmdEst = new SqlCommand(sqlEstudiante, con, trans))
                        {
                            cmdEst.Parameters.AddWithValue("@nom", txtNombres.Text.Trim());
                            cmdEst.Parameters.AddWithValue("@ape", txtApellidos.Text.Trim());
                            cmdEst.Parameters.AddWithValue("@cor", txtCorreo.Text.Trim());
                            cmdEst.Parameters.AddWithValue("@tel", txtTelefono.Text.Trim());
                            idEstudianteGenerado = Convert.ToInt64(cmdEst.ExecuteScalar());
                        }

                        // 2. Insertar Registro (numero no es IDENTITY, se calcula el siguiente correlativo)
                        string sqlRegistro = @"
                            DECLARE @SiguienteNumero INT;
                            SELECT @SiguienteNumero = ISNULL(MAX(numero), 0) + 1 FROM Registro;

                            INSERT INTO Registro (numero, id_estudiante, id_programa, id_semestre, id_participacion, id_tema, id_jornada, comentario)
                            VALUES (@SiguienteNumero, @id_est, @id_prog, @id_sem, @id_part, @id_tem, @id_jor, @com);

                            SELECT @SiguienteNumero;";

                        int numeroRegistro;
                        using (SqlCommand cmdReg = new SqlCommand(sqlRegistro, con, trans))
                        {
                            cmdReg.Parameters.AddWithValue("@id_est", idEstudianteGenerado);
                            cmdReg.Parameters.AddWithValue("@id_prog", Convert.ToInt64(ddlPrograma.SelectedValue));
                            cmdReg.Parameters.AddWithValue("@id_sem", Convert.ToInt64(ddlSemestre.SelectedValue));
                            cmdReg.Parameters.AddWithValue("@id_part", Convert.ToInt64(rblParticipacion.SelectedValue));
                            cmdReg.Parameters.AddWithValue("@id_tem", Convert.ToInt64(temaSeleccionado));
                            cmdReg.Parameters.AddWithValue("@id_jor", Convert.ToInt64(ddlJornada.SelectedValue));
                            cmdReg.Parameters.AddWithValue("@com", txtComentarios.Text.Trim());
                            numeroRegistro = Convert.ToInt32(cmdReg.ExecuteScalar());
                        }

                        trans.Commit();

                        // Actualizar UI
                        pnlFormulario.Visible = false;
                        pnlValidation.Visible = false;
                        pnlConfirmacion.Visible = true;
                        lblConfirmacion.Text = "Hola, " + txtNombres.Text.Trim() + " " + txtApellidos.Text.Trim() + ". Tu participación fue registrada exitosamente.";
                        lblCodigoRegistro.Text = "REG-" + numeroRegistro;
                        lblProgramaRegistro.Text = ddlPrograma.SelectedItem.Text;
                        lblJornadaRegistro.Text = ddlJornada.SelectedItem.Text;
                        lblErrorServidor.Visible = false;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        lblErrorServidor.Text = "Error en base de datos: " + ex.Message;
                        lblErrorServidor.Visible = true;
                    }
                }
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtIdEstudiante.Text = "";
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
            lblErrorServidor.Visible = false;
            pnlValidation.Visible = false;
            pnlConfirmacion.Visible = false;
            pnlFormulario.Visible = true;
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