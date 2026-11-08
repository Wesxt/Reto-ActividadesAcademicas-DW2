using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using UniCampus.Entities;
using WebApplication4.Presenters;
using WebApplication4.Views;

namespace WebApplication4
{
    public partial class Actividades : Page, IActividadesView
    {
        private ActividadesPresenter _presenter;

        private int ActividadSeleccionadaId
        {
            get => ViewState["ActividadSeleccionadaId"] != null ? (int)ViewState["ActividadSeleccionadaId"] : 0;
            set => ViewState["ActividadSeleccionadaId"] = value;
        }

        private int UsuarioLogueadoId => Session["UsuarioId"] != null ? Convert.ToInt32(Session["UsuarioId"]) : 0;

        protected void Page_Init(object sender, EventArgs e)
        {
            _presenter = new ActividadesPresenter(this);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            lblUsuarioNombre.Text = Server.HtmlEncode(Session["UsuarioNombre"]?.ToString() ?? "");
            lblUsuarioPrograma.Text = Server.HtmlEncode(Session["UsuarioPrograma"]?.ToString() ?? "");
            lblUsuarioRol.Text = Server.HtmlEncode(Session["UsuarioRol"]?.ToString() ?? "");

            ConfigurarPermisosPorRol(Session["UsuarioRol"]?.ToString());

            if (!IsPostBack)
            {
                txtFechaInicio.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtFechaFin.Text = DateTime.Today.AddDays(1).ToString("yyyy-MM-dd");
                _presenter.Inicializar();
            }
        }

        #region IActividadesView Implementation

        public void ConfigurarPermisosPorRol(string rol)
        {
            bool esAdmin = rol == "Administrador";
            bool esGestion = esAdmin || rol == "Docente";

            pnlAdminNav.Visible = esAdmin;
            pnlFormularioCreacion.Visible = esGestion;
            pnlInscripcionManual.Visible = esGestion;

            if (!esGestion)
            {
                workspaceContainer.Style["grid-template-columns"] = "1fr";
            }
            else
            {
                workspaceContainer.Style["grid-template-columns"] = "310px 1fr";
            }
        }

        public bool PuedeGestionar()
        {
            string rol = Session["UsuarioRol"]?.ToString();
            return rol == "Administrador" || rol == "Docente";
        }

        public bool EsAdministrador()
        {
            return (Session["UsuarioRol"]?.ToString() ?? "") == "Administrador";
        }

        public void MostrarUsuariosAdmin(IList<UsuarioDto> usuarios)
        {
            lblTotalUsuariosAdmin.Text = (usuarios?.Count ?? 0).ToString();
            gvAdminUsuarios.DataSource = usuarios;
            gvAdminUsuarios.DataBind();
        }

        public void MostrarTiposCatalogoAdmin(IList<TipoActividadDto> tipos)
        {
            gvAdminTipos.DataSource = tipos;
            gvAdminTipos.DataBind();
        }

        public bool EsAutorResena(object usuarioIdObj)
        {
            if (usuarioIdObj == null) return false;
            if (int.TryParse(usuarioIdObj.ToString(), out int autorId))
            {
                return autorId == UsuarioLogueadoId;
            }
            return false;
        }

        public void MostrarActividades(IList<ActividadDto> actividades)
        {
            gvActividades.DataSource = actividades;
            gvActividades.DataBind();
        }

        public void MostrarEstadisticas(EstadisticasDto estadisticas)
        {
            if (estadisticas == null) estadisticas = new EstadisticasDto();
            lblTotalActividades.Text = estadisticas.TotalActividades.ToString();
            lblTotalInscritos.Text = estadisticas.TotalInscritos.ToString();
            lblActividadesProximas.Text = estadisticas.ActividadesProximas.ToString();
            lblActividadesFinalizadas.Text = estadisticas.ActividadesFinalizadas.ToString();
        }

        public void MostrarDetalleActividad(ActividadDto act)
        {
            if (act == null)
            {
                OcultarDetalleActividad();
                return;
            }

            ActividadSeleccionadaId = act.ActividadId;
            pnlDetalleActividad.Visible = true;
            pnlSinSeleccion.Visible = false;

            lblDetalleTitulo.Text = Server.HtmlEncode(act.Titulo);
            lblDetalleTipo.Text = Server.HtmlEncode(act.Tipo);
            lblDetalleDescripcion.Text = string.IsNullOrWhiteSpace(act.Descripcion) ? "—" : Server.HtmlEncode(act.Descripcion);
            lblDetalleFecha.Text = Server.HtmlEncode(act.FechasFormateadas);
            lblDetalleHora.Text = Server.HtmlEncode(act.HorarioFormateado);
            lblDetalleModalidad.Text = Server.HtmlEncode(act.Modalidad);
            lblDetalleLugar.Text = Server.HtmlEncode(act.Lugar);
            lblDetalleCupos.Text = act.Cupos.ToString();
            lblDetalleEstado.Text = Server.HtmlEncode(act.Estado);
            lblDetalleEstado.CssClass = ObtenerClaseBadgeEstado(act.Estado);

            btnEstudianteInscribirme.Enabled = (act.Estado == "Activa" || act.Estado == "Próxima") && act.Cupos > 0;
            btnEstudianteInscribirme.Text = act.Cupos <= 0 ? "Cupos agotados" : "Inscribirme con mi cuenta";
        }

        public void OcultarDetalleActividad()
        {
            ActividadSeleccionadaId = 0;
            pnlDetalleActividad.Visible = false;
            pnlSinSeleccion.Visible = true;
        }

        public void MostrarEstudiantesInscritos(IList<InscripcionDto> inscritos)
        {
            lblConteoInscritos.Text = (inscritos?.Count ?? 0).ToString();
            gvInscritos.DataSource = inscritos;
            gvInscritos.DataBind();
        }

        public void MostrarResenas(IList<ResenaDto> resenas)
        {
            gvResenas.DataSource = resenas;
            gvResenas.DataBind();

            if (resenas != null && resenas.Count > 0)
            {
                double promedio = resenas.Average(r => r.Calificacion);
                lblPromedioResenas.Text = $"{promedio:0.0}/5.0 ★ ({resenas.Count})";
            }
            else
            {
                lblPromedioResenas.Text = "Sin valoraciones";
            }
        }

        public void CargarTiposActividad(IList<string> tipos)
        {
            // 1. Dropdown del formulario de registro / edición
            string seleccionadoForm = ddlTipo.SelectedValue;
            ddlTipo.Items.Clear();
            if (tipos != null)
            {
                foreach (var t in tipos)
                {
                    ddlTipo.Items.Add(new ListItem(t, t));
                }
            }
            if (!string.IsNullOrEmpty(seleccionadoForm) && ddlTipo.Items.FindByValue(seleccionadoForm) != null)
            {
                ddlTipo.SelectedValue = seleccionadoForm;
            }

            // 2. Dropdown del filtro de búsqueda en el listado
            string seleccionadoFiltro = ddlFiltroTipo.SelectedValue;
            ddlFiltroTipo.Items.Clear();
            ddlFiltroTipo.Items.Add(new ListItem("Tipo: Todos", "Todos"));
            if (tipos != null)
            {
                foreach (var t in tipos)
                {
                    ddlFiltroTipo.Items.Add(new ListItem(t, t));
                }
            }
            if (!string.IsNullOrEmpty(seleccionadoFiltro) && ddlFiltroTipo.Items.FindByValue(seleccionadoFiltro) != null)
            {
                ddlFiltroTipo.SelectedValue = seleccionadoFiltro;
            }
        }

        public void CargarListaEstudiantes(IList<UsuarioDto> estudiantes)
        {
            ddlEstudianteInscribir.Items.Clear();
            ddlEstudianteInscribir.Items.Add(new ListItem("-- Seleccione usuario --", ""));
            foreach (var est in estudiantes)
            {
                ddlEstudianteInscribir.Items.Add(new ListItem($"{est.Nombre} ({est.Programa})", est.UsuarioId.ToString()));
            }
        }

        public void MostrarMensajeExito(string mensaje)
        {
            pnlAlertExito.Visible = true;
            lblMensajeExito.Text = Server.HtmlEncode(mensaje);
            pnlAlertError.Visible = false;
        }

        public void MostrarMensajeError(string mensaje)
        {
            pnlAlertError.Visible = true;
            lblMensajeError.Text = Server.HtmlEncode(mensaje);
            pnlAlertExito.Visible = false;
        }

        public void LimpiarFormulario()
        {
            hfActividadId.Value = "0";
            txtTitulo.Text = "";
            txtDescripcion.Text = "";
            txtFechaInicio.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaFin.Text = DateTime.Today.AddDays(1).ToString("yyyy-MM-dd");
            txtHoraInicio.Text = "08:00";
            txtHoraFin.Text = "10:00";
            txtLugar.Text = "";
            txtCupos.Text = "30";
            if (ddlTipo.Items.Count > 0) ddlTipo.SelectedIndex = 0;
            ddlModalidad.SelectedIndex = 0;
            ddlEstado.SelectedIndex = 0;

            lblTituloFormulario.Text = "Registrar Actividad";
            lblModoEdicion.Visible = false;
            btnGuardar.Text = "Guardar";
        }

        public ActividadDto ObtenerDatosActividadFormulario()
        {
            int.TryParse(hfActividadId.Value, out int id);
            int.TryParse(txtCupos.Text.Trim(), out int cupos);
            DateTime.TryParse(txtFechaInicio.Text.Trim(), out DateTime fIni);
            DateTime.TryParse(txtFechaFin.Text.Trim(), out DateTime fFin);

            return new ActividadDto
            {
                ActividadId = id,
                Titulo = txtTitulo.Text.Trim(),
                Descripcion = txtDescripcion.Text.Trim(),
                Tipo = ddlTipo.SelectedValue,
                FechaInicio = fIni == DateTime.MinValue ? DateTime.Today : fIni,
                FechaFin = fFin == DateTime.MinValue ? fIni : fFin,
                HoraInicio = txtHoraInicio.Text.Trim(),
                HoraFin = txtHoraFin.Text.Trim(),
                Modalidad = ddlModalidad.SelectedValue,
                Cupos = cupos,
                Lugar = txtLugar.Text.Trim(),
                Estado = ddlEstado.SelectedValue
            };
        }

        public void CargarFormularioParaEdicion(ActividadDto act)
        {
            if (act == null) return;
            hfActividadId.Value = act.ActividadId.ToString();
            txtTitulo.Text = act.Titulo;
            txtDescripcion.Text = act.Descripcion;
            txtFechaInicio.Text = act.FechaInicio.ToString("yyyy-MM-dd");
            txtFechaFin.Text = act.FechaFin.ToString("yyyy-MM-dd");
            txtHoraInicio.Text = act.HoraInicio;
            txtHoraFin.Text = act.HoraFin;
            txtCupos.Text = act.Cupos.ToString();
            txtLugar.Text = act.Lugar;

            if (ddlTipo.Items.FindByValue(act.Tipo) != null)
                ddlTipo.SelectedValue = act.Tipo;

            if (ddlModalidad.Items.FindByValue(act.Modalidad) != null)
                ddlModalidad.SelectedValue = act.Modalidad;

            if (ddlEstado.Items.FindByValue(act.Estado) != null)
                ddlEstado.SelectedValue = act.Estado;

            lblTituloFormulario.Text = "Editar Actividad #" + act.ActividadId;
            lblModoEdicion.Visible = true;
            btnGuardar.Text = "Actualizar";
        }

        #endregion

        #region Eventos de Interfaz

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            _presenter.GuardarActividad();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            pnlAlertExito.Visible = false;
            pnlAlertError.Visible = false;
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            DateTime? fechaFiltro = null;
            if (DateTime.TryParse(txtFiltroFecha.Text.Trim(), out DateTime parsedFecha))
            {
                fechaFiltro = parsedFecha;
            }

            _presenter.CargarActividades(
                txtBuscar.Text.Trim(),
                ddlFiltroEstado.SelectedValue,
                ddlFiltroTipo.SelectedValue,
                fechaFiltro);
        }

        protected void btnRestablecer_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = "";
            ddlFiltroTipo.SelectedIndex = 0;
            ddlFiltroEstado.SelectedIndex = 0;
            txtFiltroFecha.Text = "";
            _presenter.CargarActividades();
        }

        protected void gvActividades_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (int.TryParse(e.CommandArgument?.ToString(), out int id))
            {
                switch (e.CommandName)
                {
                    case "VerDetalle":
                        _presenter.SeleccionarActividad(id);
                        break;
                    case "EditarActividad":
                        _presenter.PrepararEdicion(id);
                        break;
                    case "EliminarActividad":
                        _presenter.EliminarActividad(id);
                        break;
                }
            }
        }

        protected void btnInscribirEstudiante_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ddlEstudianteInscribir.SelectedValue, out int usuarioId) && usuarioId > 0)
            {
                _presenter.InscribirEstudiante(ActividadSeleccionadaId, usuarioId);
                ddlEstudianteInscribir.SelectedIndex = 0;
            }
            else
            {
                MostrarMensajeError("Seleccione un usuario de la lista para inscribir.");
            }
        }

        protected void btnEstudianteInscribirme_Click(object sender, EventArgs e)
        {
            if (UsuarioLogueadoId <= 0)
            {
                Response.Redirect("login.aspx");
                return;
            }
            _presenter.InscribirEstudiante(ActividadSeleccionadaId, UsuarioLogueadoId);
        }

        protected void gvInscritos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CancelarInscripcion" && int.TryParse(e.CommandArgument?.ToString(), out int inscripcionId))
            {
                _presenter.CancelarInscripcion(inscripcionId, ActividadSeleccionadaId);
            }
        }

        protected void btnPublicarResena_Click(object sender, EventArgs e)
        {
            if (UsuarioLogueadoId <= 0)
            {
                Response.Redirect("login.aspx");
                return;
            }

            int.TryParse(ddlCalificacion.SelectedValue, out int calificacion);
            _presenter.PublicarResena(ActividadSeleccionadaId, UsuarioLogueadoId, calificacion, txtComentarioResena.Text);
            txtComentarioResena.Text = "";
        }

        protected void gvResenas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EliminarResena" && int.TryParse(e.CommandArgument?.ToString(), out int resenaId))
            {
                _presenter.EliminarResena(resenaId, ActividadSeleccionadaId);
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("login.aspx");
        }

        #region Pestañas y Eventos de Administrador

        protected void btnTabActividades_Click(object sender, EventArgs e)
        {
            pnlSeccionActividades.Visible = true;
            pnlSeccionAdmin.Visible = false;
            btnTabActividades.CssClass = "tab-btn tab-btn-active";
            btnTabAdmin.CssClass = "tab-btn";
        }

        protected void btnTabAdmin_Click(object sender, EventArgs e)
        {
            pnlSeccionActividades.Visible = false;
            pnlSeccionAdmin.Visible = true;
            btnTabActividades.CssClass = "tab-btn";
            btnTabAdmin.CssClass = "tab-btn tab-btn-active";
            _presenter.CargarGestionAdmin();
        }

        protected void gvAdminUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (int.TryParse(e.CommandArgument?.ToString(), out int targetUsuarioId))
            {
                if (e.CommandName == "CambiarRol")
                {
                    var btn = (Control)e.CommandSource;
                    var row = (GridViewRow)btn.NamingContainer;
                    var ddl = (DropDownList)row.FindControl("ddlCambioRol");
                    if (ddl != null)
                    {
                        _presenter.CambiarRolUsuario(targetUsuarioId, ddl.SelectedValue, UsuarioLogueadoId);
                    }
                }
                else if (e.CommandName == "EliminarUsuario")
                {
                    _presenter.EliminarUsuario(targetUsuarioId, UsuarioLogueadoId);
                }
            }
        }

        protected void gvAdminUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var u = (UsuarioDto)e.Row.DataItem;
                var ddl = (DropDownList)e.Row.FindControl("ddlCambioRol");
                if (ddl != null && u != null)
                {
                    if (ddl.Items.FindByValue(u.Rol) != null)
                    {
                        ddl.SelectedValue = u.Rol;
                    }
                }

                var btnEliminar = (LinkButton)e.Row.FindControl("btnEliminarUsuario");
                if (btnEliminar != null && u != null && u.UsuarioId == UsuarioLogueadoId)
                {
                    btnEliminar.Visible = false; // El administrador no se puede autoeliminar
                }
            }
        }

        protected void btnCrearTipoActividad_Click(object sender, EventArgs e)
        {
            string nombre = txtNuevoTipoNombre.Text.Trim();
            string desc = txtNuevoTipoDescripcion.Text.Trim();
            if (string.IsNullOrWhiteSpace(nombre))
            {
                MostrarMensajeError("Debe ingresar el nombre del tipo o categoría de actividad.");
                return;
            }

            _presenter.CrearTipoActividad(nombre, desc);
            txtNuevoTipoNombre.Text = "";
            txtNuevoTipoDescripcion.Text = "";
        }

        protected void gvAdminTipos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EliminarTipo" && int.TryParse(e.CommandArgument?.ToString(), out int tipoId))
            {
                _presenter.EliminarTipoActividad(tipoId);
            }
        }

        public string ObtenerBadgeRol(string rol)
        {
            switch (rol?.ToLower())
            {
                case "administrador": return "<span class='tag tag-administrador'>Administrador</span>";
                case "docente": return "<span class='tag tag-docente'>Docente</span>";
                default: return "<span class='tag tag-estudiante'>Estudiante</span>";
            }
        }

        #endregion

        public string ObtenerBadgeEstado(string estado)
        {
            string clase = ObtenerClaseBadgeEstado(estado);
            return $"<span class='{clase}'>{Server.HtmlEncode(estado)}</span>";
        }

        private string ObtenerClaseBadgeEstado(string estado)
        {
            switch (estado?.ToLower())
            {
                case "activa": return "tag tag-activa";
                case "próxima":
                case "proxima": return "tag tag-proxima";
                case "finalizada": return "tag tag-finalizada";
                default: return "tag tag-tipo";
            }
        }

        #endregion
    }
}
