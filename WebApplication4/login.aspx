<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebApplication4.login" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Acceso | Plataforma de Actividades</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f4f4f5;
            color: #18181b;
            font-size: 13px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .auth-box {
            width: 100%;
            max-width: 360px;
            background: #ffffff;
            border: 1px solid #d4d4d8;
            border-radius: 4px;
            padding: 14px 16px;
        }
        .auth-header {
            border-bottom: 1px solid #e4e4e7;
            padding-bottom: 8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: baseline;
        }
        .auth-header h1 {
            font-size: 15px;
            font-weight: 700;
            margin: 0;
            color: #09090b;
        }
        .auth-header span {
            font-size: 11px;
            color: #71717a;
        }
        .tab-bar {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4px;
            background: #f4f4f5;
            padding: 3px;
            border-radius: 4px;
            margin-bottom: 12px;
        }
        .tab-btn {
            border: none;
            background: transparent;
            padding: 5px 8px;
            font-size: 12px;
            font-weight: 600;
            color: #52525b;
            cursor: pointer;
            border-radius: 3px;
            text-align: center;
        }
        .tab-btn.active {
            background: #ffffff;
            color: #09090b;
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
        }
        .field {
            margin-bottom: 8px;
        }
        .field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }
        .field label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #3f3f46;
            margin-bottom: 3px;
        }
        .field input, .field select {
            width: 100%;
            padding: 5px 8px;
            font-size: 12.5px;
            border: 1px solid #cbd5e1;
            border-radius: 3px;
            background: #ffffff;
            color: #09090b;
            outline: none;
        }
        .field input:focus, .field select:focus {
            border-color: #18181b;
        }
        .btn-submit {
            width: 100%;
            background: #18181b;
            color: #ffffff;
            border: 1px solid #18181b;
            padding: 6px 10px;
            font-size: 12.5px;
            font-weight: 600;
            border-radius: 3px;
            cursor: pointer;
            margin-top: 4px;
        }
        .btn-submit:hover {
            background: #27272a;
        }
        .msg-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 6px 8px;
            border-radius: 3px;
            font-size: 12px;
            margin-bottom: 10px;
            display: block;
        }
        .msg-ok {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
            padding: 6px 8px;
            border-radius: 3px;
            font-size: 12px;
            margin-bottom: 10px;
            display: block;
        }
        .switch-hint {
            margin-top: 10px;
            padding-top: 8px;
            border-top: 1px solid #e4e4e7;
            text-align: center;
            font-size: 11.5px;
            color: #52525b;
        }
        .switch-link {
            color: #09090b;
            font-weight: 600;
            text-decoration: underline;
            cursor: pointer;
            background: none;
            border: none;
            padding: 0;
            font-size: 11.5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="auth-box">
            <div class="auth-header">
                <h1>Gestión Académica</h1>
                <span>Acceso requerido</span>
            </div>

            <div class="tab-bar">
                <asp:Button ID="btnTabLogin" runat="server" Text="Iniciar Sesión" CssClass="tab-btn active" CausesValidation="false" OnClick="btnTabLogin_Click" />
                <asp:Button ID="btnTabRegistro" runat="server" Text="Registrarse" CssClass="tab-btn" CausesValidation="false" OnClick="btnTabRegistro_Click" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" CssClass="msg-error" Visible="false" />
            <asp:Label ID="lblExito" runat="server" CssClass="msg-ok" Visible="false" />

            <!-- PANEL LOGIN -->
            <asp:Panel ID="pnlLogin" runat="server">
                <div class="field">
                    <label>Correo electrónico o ID de usuario</label>
                    <asp:TextBox ID="txtUsuario" runat="server" placeholder="usuario@americana.edu.co" />
                </div>

                <div class="field">
                    <label>Contraseña</label>
                    <asp:TextBox ID="txtClave" runat="server" TextMode="Password" placeholder="••••••••" />
                </div>

                <asp:Button ID="btnIngresar" runat="server" Text="Entrar al sistema" CssClass="btn-submit" OnClick="btnIngresar_Click" />

                <div class="switch-hint">
                    ¿No tienes cuenta registrada?
                    <asp:LinkButton ID="lnkIrARegistro" runat="server" CssClass="switch-link" CausesValidation="false" OnClick="btnTabRegistro_Click">Regístrate aquí</asp:LinkButton>
                </div>
            </asp:Panel>

            <!-- PANEL REGISTRO -->
            <asp:Panel ID="pnlRegistro" runat="server" Visible="false">
                <div class="field">
                    <label>Nombre completo *</label>
                    <asp:TextBox ID="txtRegNombre" runat="server" placeholder="Ej: Arnold Beleño" MaxLength="100" />
                </div>

                <div class="field">
                    <label>Correo institucional *</label>
                    <asp:TextBox ID="txtRegCorreo" runat="server" placeholder="nombre@americana.edu.co" MaxLength="150" />
                </div>

                <div class="field-row">
                    <div class="field">
                        <label>Contraseña *</label>
                        <asp:TextBox ID="txtRegClave" runat="server" TextMode="Password" placeholder="Mín. 4 caracteres" MaxLength="100" />
                    </div>
                    <div class="field">
                        <label>Teléfono</label>
                        <asp:TextBox ID="txtRegTelefono" runat="server" placeholder="3001234567" MaxLength="30" />
                    </div>
                </div>

                <div class="field-row">
                    <div class="field">
                        <label>Programa *</label>
                        <asp:DropDownList ID="ddlRegPrograma" runat="server">
                            <asp:ListItem Text="Ingeniería de Sistemas" Value="Ingeniería de Sistemas" />
                            <asp:ListItem Text="Ingeniería Industrial" Value="Ingeniería Industrial" />
                            <asp:ListItem Text="Diseño Gráfico" Value="Diseño Gráfico" />
                            <asp:ListItem Text="Administración" Value="Administración" />
                            <asp:ListItem Text="Contaduría Pública" Value="Contaduría Pública" />
                            <asp:ListItem Text="Derecho" Value="Derecho" />
                        </asp:DropDownList>
                    </div>
                    <div class="field">
                        <label>Rol *</label>
                        <asp:DropDownList ID="ddlRegRol" runat="server">
                            <asp:ListItem Text="Estudiante" Value="Estudiante" />
                            <asp:ListItem Text="Docente" Value="Docente" />
                            <asp:ListItem Text="Administrador" Value="Administrador" />
                        </asp:DropDownList>
                    </div>
                </div>

                <asp:Button ID="btnCrearCuenta" runat="server" Text="Crear cuenta e ingresar" CssClass="btn-submit" OnClick="btnCrearCuenta_Click" />

                <div class="switch-hint">
                    ¿Ya tienes una cuenta?
                    <asp:LinkButton ID="lnkIrALogin" runat="server" CssClass="switch-link" CausesValidation="false" OnClick="btnTabLogin_Click">Inicia sesión</asp:LinkButton>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
