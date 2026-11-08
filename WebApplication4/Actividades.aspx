<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Actividades.aspx.cs" Inherits="WebApplication4.Actividades" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Actividades Académicas</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f4f4f5;
            color: #18181b;
            font-size: 12.5px;
            line-height: 1.35;
        }

        /* Top Bar */
        .topbar {
            background: #18181b;
            color: #fafafa;
            height: 36px;
            padding: 0 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #27272a;
        }
        .topbar-brand {
            font-weight: 700;
            font-size: 13px;
            letter-spacing: -0.2px;
        }
        .topbar-user {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 12px;
            color: #d4d4d8;
        }
        .btn-logout {
            background: #27272a;
            color: #fafafa;
            border: 1px solid #3f3f46;
            padding: 2px 8px;
            border-radius: 3px;
            text-decoration: none;
            font-size: 11.5px;
            cursor: pointer;
        }
        .btn-logout:hover {
            background: #dc2626;
            border-color: #dc2626;
            color: #fff;
        }

        /* KPI Strip */
        .kpi-strip {
            background: #ffffff;
            border-bottom: 1px solid #d4d4d8;
            padding: 5px 12px;
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 12px;
        }
        .kpi-item {
            display: flex;
            align-items: baseline;
            gap: 5px;
            color: #52525b;
        }
        .kpi-val {
            font-weight: 700;
            font-size: 13px;
            color: #09090b;
        }

        /* Alerts */
        .alert-bar {
            margin: 8px 12px 0 12px;
            padding: 6px 10px;
            border-radius: 3px;
            font-size: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .alert-ok {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
        }
        .alert-err {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }

        /* Workspace Grid */
        .workspace {
            padding: 8px 12px;
            display: grid;
            grid-template-columns: 310px 1fr;
            gap: 10px;
            align-items: start;
        }
        @media (max-width: 960px) {
            .workspace { grid-template-columns: 1fr; }
        }

        /* Panels */
        .box {
            background: #ffffff;
            border: 1px solid #d4d4d8;
            border-radius: 3px;
        }
        .box-header {
            padding: 6px 10px;
            border-bottom: 1px solid #e4e4e7;
            background: #fafafa;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 700;
            font-size: 12.5px;
            color: #09090b;
        }
        .box-body {
            padding: 8px 10px;
        }

        /* Compact Forms */
        .f-group {
            margin-bottom: 6px;
        }
        .f-row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            margin-bottom: 6px;
        }
        .f-row-3 {
            display: grid;
            grid-template-columns: 70px 1fr 100px;
            gap: 6px;
            margin-bottom: 6px;
        }
        .f-label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #3f3f46;
            margin-bottom: 2px;
        }
        .f-input, .f-select {
            width: 100%;
            padding: 4px 6px;
            font-size: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 3px;
            background: #fff;
            color: #09090b;
            font-family: inherit;
        }

        textarea.f-input {
            resize: vertical;
        }

        .f-input:focus, .f-select:focus {
            outline: none;
            border-color: #18181b;
        }
        .val-err {
            color: #dc2626;
            font-size: 10.5px;
            display: block;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 3px;
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            line-height: 1.3;
        }
        .btn-dark {
            background: #18181b;
            color: #ffffff;
            border-color: #18181b;
        }
        .btn-dark:hover { background: #27272a; }
        .btn-light {
            background: #ffffff;
            color: #3f3f46;
            border-color: #cbd5e1;
        }
        .btn-light:hover { background: #f4f4f5; }
        .btn-sm {
            padding: 2px 6px;
            font-size: 11px;
        }
        .btn-danger-sm {
            background: #fff;
            color: #b91c1c;
            border: 1px solid #fca5a5;
            padding: 2px 6px;
            font-size: 11px;
            border-radius: 2px;
            text-decoration: none;
        }
        .btn-danger-sm:hover { background: #fef2f2; }

        /* Filter Bar */
        .filter-bar {
            padding: 6px 10px;
            border-bottom: 1px solid #e4e4e7;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            align-items: center;
            background: #ffffff;
        }

        /* Tables */
        .tbl {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        .tbl th {
            background: #f4f4f5;
            color: #3f3f46;
            font-weight: 600;
            text-align: left;
            padding: 5px 8px;
            border-bottom: 1px solid #d4d4d8;
            font-size: 11px;
            text-transform: uppercase;
        }
        .tbl td {
            padding: 5px 8px;
            border-bottom: 1px solid #e4e4e7;
            vertical-align: middle;
        }
        .tbl tr:hover td {
            background-color: #fafafa;
        }

        /* Status Tags */
        .tag {
            display: inline-block;
            padding: 1px 6px;
            border-radius: 2px;
            font-size: 11px;
            font-weight: 600;
            border: 1px solid transparent;
        }
        .tag-activa { background: #f0fdf4; color: #15803d; border-color: #bbf7d0; }
        .tag-proxima { background: #fffbeb; color: #b45309; border-color: #fde68a; }
        .tag-finalizada { background: #f4f4f5; color: #52525b; border-color: #d4d4d8; }
        .tag-tipo { background: #f8fafc; color: #334155; border-color: #cbd5e1; }
        .tag-estudiante { background: #eff6ff; color: #1d4ed8; border-color: #bfdbfe; }
        .tag-docente { background: #faf5ff; color: #7e22ce; border-color: #e9d5ff; }
        .tag-administrador { background: #fff7ed; color: #c2410c; border-color: #fed7aa; }

        /* Admin Nav Tabs & Admin View */
        .sub-nav {
            display: flex;
            gap: 6px;
            padding: 4px 12px;
            background: #ffffff;
            border-bottom: 1px solid #e4e4e7;
        }
        .tab-btn {
            background: transparent;
            border: 1px solid transparent;
            padding: 4px 10px;
            font-size: 11.5px;
            font-weight: 600;
            cursor: pointer;
            border-radius: 3px;
            color: #52525b;
            text-decoration: none;
        }
        .tab-btn:hover {
            background: #f4f4f5;
            color: #18181b;
        }
        .tab-btn-active {
            background: #18181b;
            color: #ffffff !important;
            border-color: #18181b;
        }
        .admin-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 8px;
            padding: 8px 12px;
        }
        @media (max-width: 1024px) {
            .admin-grid { grid-template-columns: 1fr; }
        }

        /* Bottom 3-Column Inspector */
        .inspector-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 8px;
            margin-top: 8px;
        }
        @media (max-width: 1100px) {
            .inspector-grid { grid-template-columns: 1fr; }
        }
        .kv-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            margin-bottom: 8px;
        }
        .kv-table td {
            padding: 3px 4px;
            border-bottom: 1px solid #f4f4f5;
        }
        .kv-key {
            color: #71717a;
            font-weight: 600;
            width: 85px;
        }
        .empty-notice {
            padding: 12px;
            text-align: center;
            color: #71717a;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <!-- Slim Header Bar -->
        <header class="topbar">
            <div class="topbar-brand">UniCampus // Registro de Actividades Académicas</div>
            <div class="topbar-user">
                <span>
                    Usuario: <strong><asp:Label ID="lblUsuarioNombre" runat="server" /></strong>
                    (<asp:Label ID="lblUsuarioPrograma" runat="server" /> - <asp:Label ID="lblUsuarioRol" runat="server" />)
                </span>
                <asp:LinkButton ID="btnCerrarSesion" runat="server" CssClass="btn-logout" CausesValidation="false" OnClick="btnCerrarSesion_Click">Cerrar sesión</asp:LinkButton>
            </div>
        </header>

        <!-- Admin Navigation Tabs (Only visible for Administrador) -->
        <asp:Panel ID="pnlAdminNav" runat="server" Visible="false" CssClass="sub-nav">
            <asp:LinkButton ID="btnTabActividades" runat="server" CssClass="tab-btn tab-btn-active" CausesValidation="false" OnClick="btnTabActividades_Click">📋 Registro y Consulta de Actividades</asp:LinkButton>
            <asp:LinkButton ID="btnTabAdmin" runat="server" CssClass="tab-btn" CausesValidation="false" OnClick="btnTabAdmin_Click">⚙️ Panel Administrador: Usuarios y Categorías</asp:LinkButton>
        </asp:Panel>

        <!-- Compact KPI Strip -->
        <div class="kpi-strip">
            <div class="kpi-item">Total actividades: <span class="kpi-val"><asp:Label ID="lblTotalActividades" runat="server" Text="0" /></span></div>
            <div class="kpi-item">Inscripciones activas: <span class="kpi-val"><asp:Label ID="lblTotalInscritos" runat="server" Text="0" /></span></div>
            <div class="kpi-item">Próximas: <span class="kpi-val"><asp:Label ID="lblActividadesProximas" runat="server" Text="0" /></span></div>
            <div class="kpi-item">Finalizadas: <span class="kpi-val"><asp:Label ID="lblActividadesFinalizadas" runat="server" Text="0" /></span></div>
        </div>

        <!-- Alerts -->
        <asp:Panel ID="pnlAlertExito" runat="server" Visible="false" CssClass="alert-bar alert-ok">
            <span><strong>OK:</strong> <asp:Label ID="lblMensajeExito" runat="server" /></span>
        </asp:Panel>

        <asp:Panel ID="pnlAlertError" runat="server" Visible="false" CssClass="alert-bar alert-err">
            <span><strong>Error:</strong> <asp:Label ID="lblMensajeError" runat="server" /></span>
        </asp:Panel>

        <!-- SECTION 1: Actividades Académicas -->
        <asp:Panel ID="pnlSeccionActividades" runat="server">
            <div class="workspace" id="workspaceContainer" runat="server">
                <!-- Left Column: Compact Form -->
                <asp:Panel ID="pnlFormularioCreacion" runat="server" CssClass="box">
                <div class="box-header">
                    <asp:Label ID="lblTituloFormulario" runat="server" Text="Registrar Actividad" />
                    <asp:Label ID="lblModoEdicion" runat="server" CssClass="tag tag-proxima" Visible="false" Text="Editando" />
                </div>
                <div class="box-body">
                    <asp:HiddenField ID="hfActividadId" runat="server" Value="0" />

                    <div class="f-group">
                        <label class="f-label">Título *</label>
                        <asp:TextBox ID="txtTitulo" runat="server" CssClass="f-input" MaxLength="120" />
                        <asp:RequiredFieldValidator ID="rfvTitulo" runat="server" ControlToValidate="txtTitulo" ErrorMessage="Título obligatorio." CssClass="val-err" Display="Dynamic" ValidationGroup="vgActividad" />
                    </div>

                    <div class="f-row-2">
                        <div>
                            <label class="f-label">Tipo *</label>
                            <asp:DropDownList ID="ddlTipo" runat="server" CssClass="f-select" />
                        </div>
                        <div>
                            <label class="f-label">Modalidad *</label>
                            <asp:DropDownList ID="ddlModalidad" runat="server" CssClass="f-select">
                                <asp:ListItem Text="Presencial" Value="Presencial" Selected="True" />
                                <asp:ListItem Text="Virtual" Value="Virtual" />
                                <asp:ListItem Text="Híbrida" Value="Híbrida" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="f-group">
                        <label class="f-label">Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="2" CssClass="f-input" MaxLength="1000" />
                    </div>

                    <div class="f-row-2">
                        <div>
                            <label class="f-label">Fecha inicio *</label>
                            <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date" CssClass="f-input" />
                            <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" ErrorMessage="Requerida." CssClass="val-err" Display="Dynamic" ValidationGroup="vgActividad" />
                        </div>
                        <div>
                            <label class="f-label">Fecha fin *</label>
                            <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="f-input" />
                        </div>
                    </div>

                    <div class="f-row-2">
                        <div>
                            <label class="f-label">Hora inicio *</label>
                            <asp:TextBox ID="txtHoraInicio" runat="server" TextMode="Time" CssClass="f-input" Text="08:00" />
                        </div>
                        <div>
                            <label class="f-label">Hora fin *</label>
                            <asp:TextBox ID="txtHoraFin" runat="server" TextMode="Time" CssClass="f-input" Text="10:00" />
                        </div>
                    </div>

                    <div class="f-row-3">
                        <div>
                            <label class="f-label">Cupos *</label>
                            <asp:TextBox ID="txtCupos" runat="server" TextMode="Number" CssClass="f-input" Text="30" />
                            <asp:RangeValidator ID="rvCupos" runat="server" ControlToValidate="txtCupos" MinimumValue="0" MaximumValue="9999" Type="Integer" ErrorMessage=">= 0" CssClass="val-err" Display="Dynamic" ValidationGroup="vgActividad" />
                        </div>
                        <div>
                            <label class="f-label">Lugar *</label>
                            <asp:TextBox ID="txtLugar" runat="server" CssClass="f-input" MaxLength="150" />
                            <asp:RequiredFieldValidator ID="rfvLugar" runat="server" ControlToValidate="txtLugar" ErrorMessage="Requerido." CssClass="val-err" Display="Dynamic" ValidationGroup="vgActividad" />
                        </div>
                        <div>
                            <label class="f-label">Estado *</label>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="f-select">
                                <asp:ListItem Text="Activa" Value="Activa" Selected="True" />
                                <asp:ListItem Text="Próxima" Value="Próxima" />
                                <asp:ListItem Text="Finalizada" Value="Finalizada" />
                                <asp:ListItem Text="Cancelada" Value="Cancelada" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div style="display: flex; gap: 6px; margin-top: 8px;">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-dark" style="flex: 1;" ValidationGroup="vgActividad" OnClick="btnGuardar_Click" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-light" CausesValidation="false" OnClick="btnLimpiar_Click" />
                    </div>
                </div>
            </asp:Panel>

            <!-- Right Column: List + Inspector -->
            <div>
                <div class="box">
                    <div class="box-header">
                        <span>Listado de Actividades Académicas</span>
                    </div>

                    <!-- Multi-Filter Bar -->
                    <div class="filter-bar">
                        <asp:TextBox ID="txtBuscar" runat="server" CssClass="f-input" style="width: 180px;" placeholder="Título, descripción o lugar..." />
                        <asp:DropDownList ID="ddlFiltroTipo" runat="server" CssClass="f-select" style="width: 125px;">
                            <asp:ListItem Text="Tipo: Todos" Value="Todos" />
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="f-select" style="width: 125px;">
                            <asp:ListItem Text="Estado: Todos" Value="Todos" />
                            <asp:ListItem Text="Activa" Value="Activa" />
                            <asp:ListItem Text="Próxima" Value="Próxima" />
                            <asp:ListItem Text="Finalizada" Value="Finalizada" />
                            <asp:ListItem Text="Cancelada" Value="Cancelada" />
                        </asp:DropDownList>
                        <asp:TextBox ID="txtFiltroFecha" runat="server" TextMode="Date" CssClass="f-input" style="width: 130px;" ToolTip="Filtrar por fecha" />
                        <asp:Button ID="btnBuscar" runat="server" Text="Filtrar" CssClass="btn btn-dark btn-sm" CausesValidation="false" OnClick="btnBuscar_Click" />
                        <asp:Button ID="btnRestablecer" runat="server" Text="Restablecer" CssClass="btn btn-light btn-sm" CausesValidation="false" OnClick="btnRestablecer_Click" />
                    </div>

                    <!-- Table -->
                    <div style="overflow-x: auto;">
                        <asp:GridView ID="gvActividades" runat="server" AutoGenerateColumns="False"
                            CssClass="tbl" GridLines="None" DataKeyNames="ActividadId" OnRowCommand="gvActividades_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="ActividadId" HeaderText="ID" />
                                <asp:BoundField DataField="Titulo" HeaderText="Título" ItemStyle-Font-Bold="true" />
                                <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                                <asp:TemplateField HeaderText="Fecha">
                                    <ItemTemplate><%# Eval("FechasFormateadas") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Horario">
                                    <ItemTemplate><%# Eval("HorarioFormateado") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Lugar" HeaderText="Lugar" />
                                <asp:BoundField DataField="Modalidad" HeaderText="Modalidad" />
                                <asp:BoundField DataField="Cupos" HeaderText="Cupos" />
                                <asp:TemplateField HeaderText="Estado">
                                    <ItemTemplate><%# ObtenerBadgeEstado(Eval("Estado").ToString()) %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Acciones">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnVer" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("ActividadId") %>' CssClass="btn btn-light btn-sm">Ver</asp:LinkButton>
                                        <asp:LinkButton ID="btnEditar" runat="server" CommandName="EditarActividad" CommandArgument='<%# Eval("ActividadId") %>' CssClass="btn btn-light btn-sm" Visible='<%# PuedeGestionar() %>'>Editar</asp:LinkButton>
                                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="EliminarActividad" CommandArgument='<%# Eval("ActividadId") %>' CssClass="btn-danger-sm" Visible='<%# PuedeGestionar() %>' OnClientClick="return confirm('¿Eliminar esta actividad?');">Borrar</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-notice">No existen actividades registradas en la base de datos.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Empty Inspector State (shown when 0 activities exist or none selected) -->
                <asp:Panel ID="pnlSinSeleccion" runat="server" CssClass="box" style="margin-top: 8px;">
                    <div class="empty-notice">Seleccione o registre una actividad para consultar sus detalles, gestionar inscripciones y publicar reseñas.</div>
                </asp:Panel>

                <!-- Inspector Grid (ONLY visible when a real database activity is selected) -->
                <asp:Panel ID="pnlDetalleActividad" runat="server" Visible="false" CssClass="inspector-grid">
                    <!-- 1. Ficha Técnica e Inscripción Personal -->
                    <div class="box">
                        <div class="box-header">
                            <span>Detalle de Actividad</span>
                            <asp:Label ID="lblDetalleEstado" runat="server" />
                        </div>
                        <div class="box-body">
                            <table class="kv-table">
                                <tr><td class="kv-key">Título:</td><td><strong><asp:Label ID="lblDetalleTitulo" runat="server" /></strong></td></tr>
                                <tr><td class="kv-key">Tipo:</td><td><asp:Label ID="lblDetalleTipo" runat="server" /></td></tr>
                                <tr><td class="kv-key">Descripción:</td><td><asp:Label ID="lblDetalleDescripcion" runat="server" /></td></tr>
                                <tr><td class="kv-key">Fechas:</td><td><asp:Label ID="lblDetalleFecha" runat="server" /></td></tr>
                                <tr><td class="kv-key">Horario:</td><td><asp:Label ID="lblDetalleHora" runat="server" /></td></tr>
                                <tr><td class="kv-key">Modalidad:</td><td><asp:Label ID="lblDetalleModalidad" runat="server" /></td></tr>
                                <tr><td class="kv-key">Lugar:</td><td><asp:Label ID="lblDetalleLugar" runat="server" /></td></tr>
                                <tr><td class="kv-key">Cupos disp.:</td><td><strong><asp:Label ID="lblDetalleCupos" runat="server" /></strong></td></tr>
                            </table>

                            <asp:Button ID="btnEstudianteInscribirme" runat="server" Text="Inscribirme con mi cuenta" CssClass="btn btn-dark" style="width: 100%;" CausesValidation="false" OnClick="btnEstudianteInscribirme_Click" />
                        </div>
                    </div>

                    <!-- 2. Participantes Inscritos -->
                    <div class="box">
                        <div class="box-header">
                            <span>Participantes Inscritos (<asp:Label ID="lblConteoInscritos" runat="server" Text="0" />)</span>
                        </div>
                        <div class="box-body">
                            <asp:Panel ID="pnlInscripcionManual" runat="server" style="display: flex; gap: 4px; margin-bottom: 6px;">
                                <asp:DropDownList ID="ddlEstudianteInscribir" runat="server" CssClass="f-select" />
                                <asp:Button ID="btnInscribirEstudiante" runat="server" Text="Inscribir" CssClass="btn btn-dark btn-sm" CausesValidation="false" OnClick="btnInscribirEstudiante_Click" />
                            </asp:Panel>

                            <asp:GridView ID="gvInscritos" runat="server" AutoGenerateColumns="False"
                                CssClass="tbl" GridLines="None" OnRowCommand="gvInscritos_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="EstudianteNombre" HeaderText="Usuario" />
                                    <asp:BoundField DataField="EstudiantePrograma" HeaderText="Programa" />
                                    <asp:BoundField DataField="FechaInscripcionFormateada" HeaderText="Fecha" />
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnCancelarInscripcion" runat="server" CommandName="CancelarInscripcion" CommandArgument='<%# Eval("InscripcionId") %>' CssClass="btn-danger-sm" Visible='<%# PuedeGestionar() %>' OnClientClick="return confirm('¿Cancelar inscripción?');">Quitar</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="empty-notice">Sin participantes inscritos.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>

                    <!-- 3. Reseñas y Valoraciones (1-5) -->
                    <div class="box">
                        <div class="box-header">
                            <span>Reseñas y Valoraciones</span>
                            <asp:Label ID="lblPromedioResenas" runat="server" Text="Sin reseñas" style="font-weight: 400; font-size: 11px; color: #52525b;" />
                        </div>
                        <div class="box-body">
                            <div style="display: flex; gap: 4px; margin-bottom: 6px;">
                                <asp:DropDownList ID="ddlCalificacion" runat="server" CssClass="f-select" style="width: 75px;">
                                    <asp:ListItem Text="5 ★" Value="5" Selected="True" />
                                    <asp:ListItem Text="4 ★" Value="4" />
                                    <asp:ListItem Text="3 ★" Value="3" />
                                    <asp:ListItem Text="2 ★" Value="2" />
                                    <asp:ListItem Text="1 ★" Value="1" />
                                </asp:DropDownList>
                                <asp:TextBox ID="txtComentarioResena" runat="server" CssClass="f-input" placeholder="Escribir valoración..." MaxLength="500" />
                                <asp:Button ID="btnPublicarResena" runat="server" Text="Publicar" CssClass="btn btn-dark btn-sm" CausesValidation="false" OnClick="btnPublicarResena_Click" />
                            </div>

                            <asp:GridView ID="gvResenas" runat="server" AutoGenerateColumns="False"
                                CssClass="tbl" GridLines="None" OnRowCommand="gvResenas_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="UsuarioNombre" HeaderText="Autor" />
                                    <asp:BoundField DataField="CalificacionTexto" HeaderText="Nota" />
                                    <asp:BoundField DataField="Comentario" HeaderText="Comentario" HtmlEncode="true" />
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnBorrarResena" runat="server" CommandName="EliminarResena" CommandArgument='<%# Eval("ResenaId") %>' CssClass="btn-danger-sm" Visible='<%# PuedeGestionar() || EsAutorResena(Eval("UsuarioId")) %>'>X</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="empty-notice">No hay valoraciones registradas.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
        </asp:Panel>

        <!-- SECTION 2: Panel de Control de Administrador (Usuarios y Catálogos) -->
        <asp:Panel ID="pnlSeccionAdmin" runat="server" Visible="false">
            <div class="admin-grid">
                <!-- Subpanel 1: Gestión de Usuarios y Roles -->
                <div class="box">
                    <div class="box-header">
                        <span>Gestión de Cuentas y Asignación de Roles</span>
                        <span style="font-size: 11px; font-weight: normal; color: #71717a;">Registrados: <asp:Label ID="lblTotalUsuariosAdmin" runat="server" Text="0" /></span>
                    </div>
                    <div style="overflow-x: auto;">
                        <asp:GridView ID="gvAdminUsuarios" runat="server" AutoGenerateColumns="False"
                            CssClass="tbl" GridLines="None" DataKeyNames="UsuarioId"
                            OnRowCommand="gvAdminUsuarios_RowCommand" OnRowDataBound="gvAdminUsuarios_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="UsuarioId" HeaderText="ID" ItemStyle-Width="25px" />
                                <asp:BoundField DataField="Nombre" HeaderText="Nombre" ItemStyle-Font-Bold="true" />
                                <asp:BoundField DataField="Correo" HeaderText="Correo" />
                                <asp:BoundField DataField="Programa" HeaderText="Programa" />
                                <asp:TemplateField HeaderText="Rol Actual">
                                    <ItemTemplate>
                                        <%# ObtenerBadgeRol(Eval("Rol").ToString()) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Asignar Rol">
                                    <ItemTemplate>
                                        <div style="display: flex; gap: 3px; align-items: center;">
                                            <asp:DropDownList ID="ddlCambioRol" runat="server" CssClass="f-select" style="width: 105px; padding: 2px 4px; font-size: 11px;">
                                                <asp:ListItem Text="Estudiante" Value="Estudiante" />
                                                <asp:ListItem Text="Docente" Value="Docente" />
                                                <asp:ListItem Text="Administrador" Value="Administrador" />
                                            </asp:DropDownList>
                                            <asp:LinkButton ID="btnAplicarRol" runat="server" CommandName="CambiarRol" CommandArgument='<%# Eval("UsuarioId") %>' CssClass="btn btn-dark btn-sm" CausesValidation="false">Cambiar</asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Acción">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEliminarUsuario" runat="server" CommandName="EliminarUsuario" CommandArgument='<%# Eval("UsuarioId") %>' CssClass="btn-danger-sm" CausesValidation="false" OnClientClick="return confirm('¿Está seguro de eliminar este usuario? Sus inscripciones y reseñas asociadas se removerán.');">Eliminar</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-notice">No hay usuarios registrados.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Subpanel 2: Gestión de Catálogo de Tipos de Actividad -->
                <div class="box">
                    <div class="box-header">
                        <span>Catálogo de Tipos de Actividad Académica</span>
                    </div>
                    <div class="box-body">
                        <!-- Form to Add Type -->
                        <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 3px; padding: 8px; margin-bottom: 8px;">
                            <div style="font-weight: 600; font-size: 11.5px; margin-bottom: 5px; color: #1e293b;">Agregar Nueva Categoría / Tipo</div>
                            <div class="f-group" style="margin-bottom: 4px;">
                                <label class="f-label">Nombre *</label>
                                <asp:TextBox ID="txtNuevoTipoNombre" runat="server" CssClass="f-input" placeholder="Ej: Hackathon, Coloquio..." MaxLength="50" />
                            </div>
                            <div class="f-group" style="margin-bottom: 6px;">
                                <label class="f-label">Descripción</label>
                                <asp:TextBox ID="txtNuevoTipoDescripcion" runat="server" CssClass="f-input" placeholder="Breve descripción del formato..." MaxLength="250" />
                            </div>
                            <asp:Button ID="btnCrearTipoActividad" runat="server" Text="+ Guardar Categoría" CssClass="btn btn-dark btn-sm" CausesValidation="false" OnClick="btnCrearTipoActividad_Click" />
                        </div>

                        <div style="overflow-x: auto;">
                            <asp:GridView ID="gvAdminTipos" runat="server" AutoGenerateColumns="False"
                                CssClass="tbl" GridLines="None" DataKeyNames="TipoId" OnRowCommand="gvAdminTipos_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="TipoId" HeaderText="ID" ItemStyle-Width="25px" />
                                    <asp:BoundField DataField="Nombre" HeaderText="Tipo" ItemStyle-Font-Bold="true" />
                                    <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                                    <asp:TemplateField HeaderText="Acción" ItemStyle-Width="55px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEliminarTipo" runat="server" CommandName="EliminarTipo" CommandArgument='<%# Eval("TipoId") %>' CssClass="btn-danger-sm" CausesValidation="false" OnClientClick="return confirm('¿Eliminar esta categoría?');">Borrar</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="empty-notice">No hay categorías registradas en el catálogo.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </form>
</body>
</html>
