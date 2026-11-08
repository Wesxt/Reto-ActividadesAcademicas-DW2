<%@ Page Title="Registro de Participación" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FormularioWeb.aspx.cs" Inherits="WebApplication4.FormularioWeb" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="stylesheet1.css" rel="stylesheet" type="text/css" />

    <asp:Panel ID="pnlValidation" runat="server" CssClass="validation-panel" Visible="false">
        <h3>VALIDACIÓN DEL FORMULARIO</h3>
        <div class="validation-intro">Revise los siguientes campos antes de continuar:</div>
        <asp:ValidationSummary ID="vsResumen" runat="server" ShowMessageBox="false" ShowSummary="true" CssClass="validation-list" DisplayMode="List" />
    </asp:Panel>

    <asp:Panel ID="pnlFormulario" runat="server" CssClass="form">
        <h2 class="form-title-2" style="grid-column-start: 1;
grid-column-end: 3;
color: #173b69;
font-size: 22px;
font-weight: 700;
margin-bottom: 20px;
border-bottom: 2px solid #f1f5f9;
padding-bottom: 10px;">Formulario de Registro de Participación</h2>

        <!-- Fila 1 -->
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="txtIdEstudiante" Text="Documento / ID Estudiante:"></asp:Label>
            <asp:TextBox ID="txtIdEstudiante" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvIdEstudiante" runat="server" ControlToValidate="txtIdEstudiante" ErrorMessage="Documento: este campo es obligatorio." Display="Dynamic" CssClass="text-danger" />
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="txtTelefono" Text="Teléfono (Clave de acceso):"></asp:Label>
            <asp:TextBox ID="txtTelefono" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="Teléfono: este campo es obligatorio." Display="Dynamic" CssClass="text-danger" />
            <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="Teléfono: formato no válido (7 a 15 dígitos)." Display="Dynamic" CssClass="text-danger" ValidationExpression="^\+?\d{7,15}$" />
        </div>

        <!-- Fila 2 -->
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="txtNombres" Text="Nombres:"></asp:Label>
            <asp:TextBox ID="txtNombres" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvNombres" runat="server" ControlToValidate="txtNombres" ErrorMessage="Nombres: este campo es obligatorio." Display="Dynamic" CssClass="text-danger" />
            <asp:CustomValidator ID="cvNombres" runat="server" ControlToValidate="txtNombres" ErrorMessage="Nombres: este campo no puede estar vacío." OnServerValidate="cvNombres_ServerValidate" Display="Dynamic" CssClass="text-danger" />
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="txtApellidos" Text="Apellidos:"></asp:Label>
            <asp:TextBox ID="txtApellidos" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvApellidos" runat="server" ControlToValidate="txtApellidos" ErrorMessage="Apellidos: este campo es obligatorio." Display="Dynamic" CssClass="text-danger" />
            <asp:CustomValidator ID="cvApellidos" runat="server" ControlToValidate="txtApellidos" ErrorMessage="Apellidos: este campo no puede estar vacío." OnServerValidate="cvApellidos_ServerValidate" Display="Dynamic" CssClass="text-danger" />
        </div>

        <!-- Fila 3 -->
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="txtCorreo" Text="Correo Electrónico:"></asp:Label>
            <asp:TextBox ID="txtCorreo" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtCorreo" ErrorMessage="Correo electrónico: este campo es obligatorio." Display="Dynamic" CssClass="text-danger" />
            <asp:RegularExpressionValidator ID="revCorreo" runat="server" ControlToValidate="txtCorreo" ErrorMessage="Correo: debe tener un formato válido." Display="Dynamic" CssClass="text-danger" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" />
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ddlPrograma" Text="Programa académico:"></asp:Label>
            <asp:DropDownList ID="ddlPrograma" runat="server"></asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvPrograma" runat="server" ControlToValidate="ddlPrograma" InitialValue="" ErrorMessage="Programa académico: seleccione una opción." Display="Dynamic" CssClass="text-danger" />
        </div>

        <!-- Fila 4 -->
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ddlSemestre" Text="Semestre:"></asp:Label>
            <asp:DropDownList ID="ddlSemestre" runat="server"></asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvSemestre" runat="server" ControlToValidate="ddlSemestre" InitialValue="" ErrorMessage="Semestre: seleccione una opción." Display="Dynamic" CssClass="text-danger" />
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ddlJornada" Text="Jornada:"></asp:Label>
            <asp:DropDownList ID="ddlJornada" runat="server"></asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvJornada" runat="server" ControlToValidate="ddlJornada" InitialValue="" ErrorMessage="Jornada: seleccione una opción." Display="Dynamic" CssClass="text-danger" />
        </div>

        <!-- Fila 5 -->
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="rblParticipacion" Text="Tipo de participación:"></asp:Label>
            <asp:RadioButtonList ID="rblParticipacion" runat="server" RepeatDirection="Horizontal"></asp:RadioButtonList>
            <asp:RequiredFieldValidator ID="rfvParticipacion" runat="server" ControlToValidate="rblParticipacion" ErrorMessage="Tipo de participación: seleccione una opción." Display="Dynamic" CssClass="text-danger" />
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="cblTemas" Text="Temas de interés:"></asp:Label>
            <asp:CheckBoxList ID="cblTemas" runat="server"></asp:CheckBoxList>
            <asp:CustomValidator ID="cvTemas" runat="server" ErrorMessage="Temas de interés: seleccione al menos un tema." OnServerValidate="cvTemas_ServerValidate" Display="Dynamic" CssClass="text-danger" />
        </div>

        <!-- Fila 6 (Ancho completo) -->
        <div class="form-group full-width">
            <asp:Label runat="server" AssociatedControlID="txtComentarios" Text="Comentarios:"></asp:Label>
            <asp:TextBox ID="txtComentarios" runat="server" TextMode="MultiLine" Rows="3" MaxLength="500"></asp:TextBox>
        </div>

        <!-- Aceptación -->
        <div class="form-group auth">
            <asp:CheckBox ID="chkAcepta" runat="server" />
            <asp:Label runat="server" AssociatedControlID="chkAcepta" Text="Acepto el tratamiento de mis datos para fines académicos"></asp:Label>
            <asp:CustomValidator ID="cvAcepta" runat="server" ErrorMessage="Aceptación: debe aceptar el tratamiento de datos." OnServerValidate="cvAcepta_ServerValidate" Display="Dynamic" CssClass="text-danger" />
        </div>

        <asp:Label ID="lblErrorServidor" runat="server" CssClass="text-danger full-width" Visible="false"></asp:Label>

        <!-- Botones de Acción -->
        <div class="form-actions">
            <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" OnClick="btnRegistrar_Click" CssClass="btn-primary" />
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" OnClick="btnLimpiar_Click" CausesValidation="false" CssClass="btn-outline" />
            <a href="login.aspx" class="btn-outline">Ir al Login</a>
        </div>
    </asp:Panel>

    <!-- Panel de Confirmación -->
    <asp:Panel ID="pnlConfirmacion" runat="server" CssClass="confirmation-panel" Visible="false">
        <h2>REGISTRO COMPLETADO</h2>
        <p class="confirmation-success">¡Registro realizado correctamente en la base de datos!</p>
        <div class="confirmation-message">
            <asp:Label ID="lblConfirmacion" runat="server"></asp:Label>
        </div>
        <p class="confirmation-detail">Código de registro: <asp:Label ID="lblCodigoRegistro" runat="server" Font-Bold="true"></asp:Label></p>
        <p class="confirmation-detail">
            Programa: <asp:Label ID="lblProgramaRegistro" runat="server"></asp:Label>
            <span class="separator">|</span>
            Jornada: <asp:Label ID="lblJornadaRegistro" runat="server"></asp:Label>
        </p>
        <div class="actions">
            <asp:Button ID="btnNuevoRegistro" runat="server" Text="Nuevo Registro" CssClass="btn-primary" OnClick="btnNuevoRegistro_Click" CausesValidation="false" />
            <a href="login.aspx" class="btn-outline">Iniciar Sesión</a>
        </div>
    </asp:Panel>
</asp:Content>