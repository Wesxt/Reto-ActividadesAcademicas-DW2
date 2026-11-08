using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication4
{
    public partial class crud : System.Web.UI.Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioLogueado"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarRegistros();
            }
        }

        private void CargarRegistros()
        {
            string query = @"
                SELECT 
                    r.numero,
                    r.id_estudiante,
                    (e.nombre + ' ' + e.apellidos) AS EstudianteNombre,
                    p.nombre AS Programa,
                    s.descripcion AS Semestre,
                    tp.description AS Tipo_participacion,
                    t.description AS Tema,
                    j.description AS Jornada,
                    r.comentario
                FROM Registro r
                INNER JOIN Estudiante e ON r.id_estudiante = e.id_estudiante
                INNER JOIN Programa p ON r.id_programa = p.id_programa
                INNER JOIN Semestre s ON r.id_semestre = s.id_semestre
                INNER JOIN Tipo_participacion tp ON r.id_participacion = tp.id_participacion
                INNER JOIN Tema t ON r.id_tema = t.id_tema
                INNER JOIN Jornada j ON r.id_jornada = j.id_jornada
                ORDER BY r.numero DESC";

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvRegistros.DataSource = dt;
                    gvRegistros.DataBind();
                }
            }
        }

        protected void gvRegistros_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvRegistros.EditIndex = e.NewEditIndex;
            CargarRegistros();
        }

        protected void gvRegistros_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvRegistros.EditIndex = -1;
            CargarRegistros();
        }

        protected void gvRegistros_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int numero = Convert.ToInt32(gvRegistros.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvRegistros.Rows[e.RowIndex];
            string nuevoComentario = ((TextBox)row.Cells[8].Controls[0]).Text.Trim();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "UPDATE Registro SET comentario = @com WHERE numero = @num";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@com", nuevoComentario);
                    cmd.Parameters.AddWithValue("@num", numero);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvRegistros.EditIndex = -1;
            CargarRegistros();
        }

        protected void gvRegistros_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int numero = Convert.ToInt32(gvRegistros.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "DELETE FROM Registro WHERE numero = @num";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@num", numero);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            CargarRegistros();
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
    }
}