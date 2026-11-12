<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Actividades.aspx.cs" Inherits="WebApplication4.Actividades" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>UniCampus | Sistema de Gestión Académica</title>
    <style>
        :root {
            --navy-header: #0e1b38;
            --navy-sidebar: #0c1736;
            --blue-primary: #2563eb;
            --blue-hover: #1d4ed8;
            --bg-canvas: #f0f4f9;
            --card-bg: #ffffff;
            --border-card: #e2e8f0;
            --border-light: #f1f5f9;
            --text-heading: #0d234a;
            --text-body: #1e293b;
            --text-muted: #64748b;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--bg-canvas);
            color: var(--text-body);
            font-size: 13px;
            line-height: 1.45;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 1. TOP NAVBAR */
        .topbar {
            background-color: var(--navy-header);
            color: #ffffff;
            height: 64px;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }
        .topbar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #ffffff;
        }
        .brand-icon-wrap {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
        }
        .brand-titles {
            display: flex;
            flex-direction: column;
        }
        .brand-main-title {
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -0.3px;
            line-height: 1.1;
        }
        .brand-sub-title {
            font-size: 11.5px;
            color: #94a3b8;
            font-weight: 400;
        }

        .topbar-right {
            display: flex;
            align-items: center;
        }
        .user-widget {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 2px 4px;
            user-select: none;
        }
        .avatar-circle {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: #3b82f6;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
        }
        .user-text-meta {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
        }
        .user-name {
            font-size: 13px;
            font-weight: 600;
            color: #ffffff;
        }
        .user-role {
            font-size: 11px;
            color: #93c5fd;
        }

        /* 2. LAYOUT WRAPPER */
        .app-body {
            display: flex;
            flex: 1;
            min-height: calc(100vh - 64px);
        }

        /* 3. SIDEBAR */
        .sidebar {
            width: 230px;
            background-color: var(--navy-sidebar);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 16px 12px;
            flex-shrink: 0;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }
        .sidebar-menu {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            border-radius: 8px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.15s ease;
            border: none;
            background: transparent;
            width: 100%;
            text-align: left;
            cursor: pointer;
        }
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.08);
            color: #ffffff;
        }
        .nav-item.active {
            background-color: var(--blue-primary);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
        }
        .nav-icon {
            width: 18px;
            height: 18px;
            stroke-width: 2;
            flex-shrink: 0;
        }
        .sidebar-bottom {
            padding-top: 16px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        .logout-btn {
            color: #f87171 !important;
        }
        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.15) !important;
            color: #ffffff !important;
        }

        /* 4. MAIN CONTENT */
        .main-canvas {
            flex: 1;
            padding: 24px 30px;
            overflow-y: auto;
        }

        /* Top Heading */
        .page-header {
            margin-bottom: 20px;
        }
        .page-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.4px;
            margin-bottom: 4px;
        }
        .page-subtitle {
            font-size: 13.5px;
            color: var(--text-muted);
        }

        /* KPI Strip & Banner Row */
        .kpi-banner-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr) 300px;
            gap: 14px;
            margin-bottom: 22px;
            align-items: stretch;
        }
        @media (max-width: 1200px) {
            .kpi-banner-row {
                grid-template-columns: repeat(2, 1fr);
            }
            .banner-students-card {
                grid-column: span 2;
            }
        }

        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-card);
            border-radius: 12px;
            padding: 14px 16px;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        }
        .stat-icon-wrap {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .icon-blue { background: #eff6ff; color: #2563eb; }
        .icon-green { background: #ecfdf5; color: #10b981; }
        .icon-orange { background: #fffbeb; color: #f59e0b; }
        .icon-red { background: #fef2f2; color: #ef4444; }

        .stat-info {
            display: flex;
            flex-direction: column;
        }
        .stat-number {
            font-size: 22px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.1;
        }
        .stat-label {
            font-size: 11.5px;
            color: var(--text-muted);
            margin-top: 3px;
            font-weight: 500;
        }

        .banner-students-card {
            background: linear-gradient(135deg, #f8fafc 0%, #eff6ff 100%);
            border: 1px solid #dbeafe;
            border-radius: 12px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }
        .banner-students-card img {
            width: 100%;
            height: 100%;
            max-height: 80px;
            object-fit: contain;
        }

        /* Notifications & Alerts */
        .toast-msg {
            padding: 10px 14px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 12.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .toast-ok { background: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; }
        .toast-err { background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; }

        /* MIDDLE SECTION: 2 COLUMNS (Form + Table) */
        .grid-middle {
            display: grid;
            grid-template-columns: 440px 1fr;
            gap: 20px;
            margin-bottom: 22px;
            align-items: start;
        }
        .grid-middle.solo-tabla {
            grid-template-columns: 1fr;
        }
        @media (max-width: 1024px) {
            .grid-middle { grid-template-columns: 1fr; }
        }

        /* Standard Modern Card */
        .app-card {
            background: var(--card-bg);
            border: 1px solid var(--border-card);
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }
        .card-header-styled {
            padding: 14px 18px;
            border-bottom: 1px solid #eef2f6;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #ffffff;
        }
        .header-title-flex {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .header-circle-icon {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .header-title-text {
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
        }
        .card-body-styled {
            padding: 16px 18px;
        }

        /* Form Inputs */
        .form-grid-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 12px;
        }
        .form-grid-row-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 12px;
            margin-bottom: 12px;
        }
        .field-box {
            display: flex;
            flex-direction: column;
            gap: 4px;
            margin-bottom: 12px;
        }
        .field-label {
            font-size: 11.5px;
            font-weight: 600;
            color: #334155;
        }
        .field-req {
            color: #ef4444;
        }
        .form-input, .form-select {
            width: 100%;
            padding: 7px 10px;
            font-size: 12.5px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            color: #0f172a;
            background: #ffffff;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        .form-input:focus, .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }
        textarea.form-input {
            resize: vertical;
            min-height: 60px;
        }

        /* Buttons */
        .btn-primary-blue {
            background-color: var(--blue-primary);
            color: #ffffff;
            border: 1px solid var(--blue-hover);
            padding: 8px 16px;
            font-size: 12.5px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.15s;
        }
        .btn-primary-blue:hover {
            background-color: var(--blue-hover);
        }
        .btn-light-outline {
            background-color: #ffffff;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 8px 16px;
            font-size: 12.5px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.15s;
        }
        .btn-light-outline:hover {
            background-color: #f8fafc;
            color: #0f172a;
        }
        .btn-green-sm {
            background-color: #16a34a;
            color: #ffffff;
            border: 1px solid #15803d;
            padding: 5px 12px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: background 0.15s;
        }
        .btn-green-sm:hover {
            background-color: #15803d;
        }

        /* Table Styling */
        .table-search-wrap {
            display: flex;
            align-items: center;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 4px 8px;
            width: 220px;
        }
        .table-search-input {
            border: none;
            outline: none;
            font-size: 12px;
            color: #0f172a;
            width: 100%;
            background: transparent;
        }
        .table-search-btn {
            background: none;
            border: none;
            color: #64748b;
            cursor: pointer;
            display: flex;
            align-items: center;
            padding: 0;
        }
        .table-search-btn:hover {
            color: #2563eb;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12.5px;
        }
        .data-table th {
            background: #f8fafc;
            color: #64748b;
            font-weight: 600;
            text-align: left;
            padding: 10px 12px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 11.5px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .data-table td {
            padding: 10px 12px;
            border-bottom: 1px solid #f1f5f9;
            color: #1e293b;
            vertical-align: middle;
        }
        .data-table tr:hover td {
            background-color: #f8fafc;
        }

        /* Status Pills */
        .badge-pill {
            display: inline-block;
            padding: 3px 12px;
            border-radius: 9999px;
            font-size: 11.5px;
            font-weight: 600;
            text-align: center;
            line-height: 1.35;
        }
        .badge-activa {
            background-color: #dcfce7;
            color: #15803d;
        }
        .badge-proxima {
            background-color: #fef3c7;
            color: #b45309;
        }
        .badge-finalizada {
            background-color: #f1f5f9;
            color: #475569;
        }
        .badge-cancelada {
            background-color: #fee2e2;
            color: #b91c1c;
        }
        .badge-tipo {
            background-color: #eff6ff;
            color: #2563eb;
        }

        /* Table Action Buttons */
        .table-actions-flex {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .action-sq-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 6px;
            color: #ffffff !important;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: opacity 0.15s, transform 0.05s;
        }
        .action-sq-btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        .btn-action-view { background-color: #2563eb; }
        .btn-action-edit { background-color: #3b82f6; }
        .btn-action-delete { background-color: #ef4444; }

        /* Table Pagination & Foot */
        .table-footer-bar {
            padding: 10px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-top: 1px solid #f1f5f9;
            font-size: 12px;
            color: var(--text-muted);
        }
        .pagination-ctrls {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .page-num {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 11.5px;
            color: #475569;
            background: #ffffff;
            border: 1px solid #cbd5e1;
        }
        .page-num.active {
            background-color: #2563eb;
            color: #ffffff;
            border-color: #2563eb;
            font-weight: 600;
        }

        /* BOTTOM ROW: 3 CARDS */
        .grid-bottom-3 {
            display: grid;
            grid-template-columns: 1fr 1.15fr 1fr;
            gap: 20px;
            align-items: stretch;
            margin-bottom: 24px;
        }
        @media (max-width: 1100px) {
            .grid-bottom-3 { grid-template-columns: 1fr; }
        }

        /* Card 1: Details Key-Value */
        .kv-row {
            display: flex;
            padding: 6px 0;
            border-bottom: 1px solid #f8fafc;
            font-size: 12px;
        }
        .kv-title {
            width: 90px;
            font-weight: 700;
            color: #0f172a;
            flex-shrink: 0;
        }
        .kv-value {
            color: #334155;
            flex: 1;
        }

        /* Card 3: Student View */
        .preview-img-box {
            width: 100%;
            height: 125px;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 12px;
            background: #1e293b;
        }
        .preview-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .preview-title {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 6px;
        }
        .preview-badges {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 10px;
        }
        .preview-meta-list {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-bottom: 10px;
            font-size: 12px;
            color: #475569;
        }
        .preview-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .preview-desc {
            font-size: 11.5px;
            color: #64748b;
            line-height: 1.4;
            margin-bottom: 14px;
        }
        .btn-inscribirme {
            width: 100%;
            background-color: var(--blue-primary);
            color: #ffffff;
            border: none;
            padding: 10px 14px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.15s;
        }
        .btn-inscribirme:hover {
            background-color: var(--blue-hover);
        }
        .btn-inscribirme:disabled {
            background-color: #94a3b8;
            cursor: not-allowed;
            opacity: 0.75;
        }

        /* Admin Pill Nav */
        .admin-nav-bar {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }
        .tab-pill {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
            color: #475569;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            cursor: pointer;
        }
        .tab-pill.active {
            background-color: #0f172a;
            color: #ffffff;
            border-color: #0f172a;
        }
        .admin-cards-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 16px;
        }
        @media (max-width: 1024px) {
            .admin-cards-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <!-- 1. TOP NAVBAR -->
        <header class="topbar">
            <a href="Actividades.aspx" class="topbar-brand">
                <div class="brand-icon-wrap">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                    </svg>
                </div>
                <div class="brand-titles">
                    <span class="brand-main-title">UniCampus</span>
                    <span class="brand-sub-title">Sistema de Gestión Académica</span>
                </div>
            </a>

            <div class="topbar-right">
                <!-- User profile static display -->
                <div class="user-widget">
                    <div class="avatar-circle">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="7" r="4"/>
                            <path d="M4 21v-2a4 4 0 0 1 4-4h8a4 4 0 0 1 4 4v2"/>
                        </svg>
                    </div>
                    <div class="user-text-meta">
                        <span class="user-name"><asp:Label ID="lblUsuarioNombre" runat="server" Text="María López" /></span>
                        <span class="user-role"><asp:Label ID="lblUsuarioRol" runat="server" Text="Estudiante" /></span>
                        <asp:Label ID="lblUsuarioPrograma" runat="server" style="display:none;" />
                    </div>
                </div>
            </div>
        </header>

        <!-- 2. BODY LAYOUT (Sidebar + Main Area) -->
        <div class="app-body">
            <!-- LEFT SIDEBAR (Only active & real modules) -->
            <aside class="sidebar">
                <nav class="sidebar-menu">
                    <a href="Actividades.aspx" class="nav-item active">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                        <span>Actividades Académicas</span>
                    </a>
                </nav>

                <div class="sidebar-bottom">
                    <asp:LinkButton ID="btnCerrarSesion" runat="server" CssClass="nav-item logout-btn" CausesValidation="false" OnClick="btnCerrarSesion_Click">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                        <span>Cerrar sesión</span>
                    </asp:LinkButton>
                </div>
            </aside>

            <!-- MAIN CANVAS -->
            <main class="main-canvas">
                <!-- Header -->
                <div class="page-header">
                    <h1 class="page-title">Registro de Actividades Académicas</h1>
                    <p class="page-subtitle">Administra, registra y consulta las actividades académicas de la institución.</p>
                </div>

                <!-- Admin Tabs (Visible for Administrador) -->
                <asp:Panel ID="pnlAdminNav" runat="server" Visible="false" CssClass="admin-nav-bar">
                    <asp:LinkButton ID="btnTabActividades" runat="server" CssClass="tab-pill active" CausesValidation="false" OnClick="btnTabActividades_Click">📋 Registro y Consulta</asp:LinkButton>
                    <asp:LinkButton ID="btnTabAdmin" runat="server" CssClass="tab-pill" CausesValidation="false" OnClick="btnTabAdmin_Click">⚙️ Panel Administrador: Usuarios y Categorías</asp:LinkButton>
                </asp:Panel>

                <!-- Alerts -->
                <asp:Panel ID="pnlAlertExito" runat="server" Visible="false" CssClass="toast-msg toast-ok">
                    <span><strong>Éxito:</strong> <asp:Label ID="lblMensajeExito" runat="server" /></span>
                </asp:Panel>
                <asp:Panel ID="pnlAlertError" runat="server" Visible="false" CssClass="toast-msg toast-err">
                    <span><strong>Atención:</strong> <asp:Label ID="lblMensajeError" runat="server" /></span>
                </asp:Panel>

                <!-- SECTION 1: ACTIVIDADES ACADÉMICAS -->
                <asp:Panel ID="pnlSeccionActividades" runat="server">
                    <!-- KPI Cards & Student Banner Illustration Row -->
                    <div class="kpi-banner-row">
                        <!-- Card 1: Total -->
                        <div class="stat-card">
                            <div class="stat-icon-wrap icon-blue">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number"><asp:Label ID="lblTotalActividades" runat="server" Text="12" /></span>
                                <span class="stat-label">Total de actividades</span>
                            </div>
                        </div>

                        <!-- Card 2: Estudiantes Inscritos -->
                        <div class="stat-card">
                            <div class="stat-icon-wrap icon-green">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number"><asp:Label ID="lblTotalInscritos" runat="server" Text="340" /></span>
                                <span class="stat-label">Estudiantes inscritos</span>
                            </div>
                        </div>

                        <!-- Card 3: Actividades Próximas -->
                        <div class="stat-card">
                            <div class="stat-icon-wrap icon-orange">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number"><asp:Label ID="lblActividadesProximas" runat="server" Text="8" /></span>
                                <span class="stat-label">Actividades próximas</span>
                            </div>
                        </div>

                        <!-- Card 4: Actividades Finalizadas -->
                        <div class="stat-card">
                            <div class="stat-icon-wrap icon-red">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            </div>
                            <div class="stat-info">
                                <span class="stat-number"><asp:Label ID="lblActividadesFinalizadas" runat="server" Text="4" /></span>
                                <span class="stat-label">Actividades finalizadas</span>
                            </div>
                        </div>

                        <!-- Banner Illustration -->
                        <div class="banner-students-card">
                            <img src="Content/images/students-banner.svg" alt="UniCampus Estudiantes" />
                        </div>
                    </div>

                    <!-- Hidden workspace container reference to avoid any null ref -->
                    <div id="workspaceContainer" runat="server" style="display:none;"></div>

                    <!-- MIDDLE SECTION: FORM + TABLE GRID -->
                    <div class="grid-middle <%= PuedeGestionar() ? "" : "solo-tabla" %>">
                        <!-- LEFT COLUMN: Nueva Actividad Académica Form Card -->
                        <asp:Panel ID="pnlFormularioCreacion" runat="server" CssClass="app-card">
                            <div class="card-header-styled">
                                <div class="header-title-flex">
                                    <div class="header-circle-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                    </div>
                                    <span class="header-title-text"><asp:Label ID="lblTituloFormulario" runat="server" Text="Nueva Actividad Académica" /></span>
                                </div>
                                <asp:Label ID="lblModoEdicion" runat="server" CssClass="badge-pill badge-proxima" Visible="false" Text="Editando" />
                            </div>

                            <div class="card-body-styled">
                                <asp:HiddenField ID="hfActividadId" runat="server" Value="0" />

                                <!-- Row 1: Título & Tipo -->
                                <div class="form-grid-row">
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Título de la actividad <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-input" placeholder="Taller de Programación Web" MaxLength="120" />
                                        <asp:RequiredFieldValidator ID="rfvTitulo" runat="server" ControlToValidate="txtTitulo" ErrorMessage="Título requerido." Display="Dynamic" ForeColor="#ef4444" ValidationGroup="vgActividad" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Tipo de actividad <span class="field-req">*</span></label>
                                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select" />
                                    </div>
                                </div>

                                <!-- Row 2: Descripción & Fechas -->
                                <div class="field-box">
                                    <label class="field-label">Descripción <span class="field-req">*</span></label>
                                    <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-input" placeholder="Espacio práctico para reforzar conceptos de programación web con ASP.NET." MaxLength="1000" />
                                </div>

                                <div class="form-grid-row">
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Fecha de inicio <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date" CssClass="form-input" />
                                        <asp:RequiredFieldValidator ID="rfvFechaInicio" runat="server" ControlToValidate="txtFechaInicio" ErrorMessage="Fecha requerida." Display="Dynamic" ForeColor="#ef4444" ValidationGroup="vgActividad" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Fecha de fin <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="form-input" />
                                    </div>
                                </div>

                                <!-- Row 3: Horas & Modalidad -->
                                <div class="form-grid-row-3">
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Hora de inicio <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtHoraInicio" runat="server" TextMode="Time" CssClass="form-input" Text="08:00" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Hora de fin <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtHoraFin" runat="server" TextMode="Time" CssClass="form-input" Text="12:00" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Modalidad <span class="field-req">*</span></label>
                                        <asp:DropDownList ID="ddlModalidad" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Presencial" Value="Presencial" Selected="True" />
                                            <asp:ListItem Text="Virtual" Value="Virtual" />
                                            <asp:ListItem Text="Híbrida" Value="Híbrida" />
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <!-- Row 4: Cupos, Lugar & Estado -->
                                <div class="form-grid-row-3">
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Cupos disponibles <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtCupos" runat="server" TextMode="Number" CssClass="form-input" Text="30" />
                                        <asp:RangeValidator ID="rvCupos" runat="server" ControlToValidate="txtCupos" MinimumValue="0" MaximumValue="9999" Type="Integer" ErrorMessage=">= 0" Display="Dynamic" ForeColor="#ef4444" ValidationGroup="vgActividad" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Lugar <span class="field-req">*</span></label>
                                        <asp:TextBox ID="txtLugar" runat="server" CssClass="form-input" placeholder="Laboratorio 3" MaxLength="150" />
                                        <asp:RequiredFieldValidator ID="rfvLugar" runat="server" ControlToValidate="txtLugar" ErrorMessage="Requerido." Display="Dynamic" ForeColor="#ef4444" ValidationGroup="vgActividad" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 0;">
                                        <label class="field-label">Estado <span class="field-req">*</span></label>
                                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Activa" Value="Activa" Selected="True" />
                                            <asp:ListItem Text="Próxima" Value="Próxima" />
                                            <asp:ListItem Text="Finalizada" Value="Finalizada" />
                                            <asp:ListItem Text="Cancelada" Value="Cancelada" />
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <!-- Actions -->
                                <div style="display: flex; gap: 8px; margin-top: 14px;">
                                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn-primary-blue" ValidationGroup="vgActividad" OnClick="btnGuardar_Click" />
                                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-light-outline" CausesValidation="false" OnClick="btnLimpiar_Click" />
                                </div>
                            </div>
                        </asp:Panel>

                        <!-- RIGHT COLUMN: Listado de Actividades Table Card -->
                        <div class="app-card">
                            <div class="card-header-styled">
                                <div class="header-title-flex">
                                    <div class="header-circle-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                                    </div>
                                    <span class="header-title-text">Listado de Actividades Académicas</span>
                                </div>

                                <!-- Search Box Matching Image -->
                                <div class="table-search-wrap">
                                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="table-search-input" placeholder="Buscar actividad..." />
                                    <asp:LinkButton ID="btnBuscar" runat="server" CssClass="table-search-btn" CausesValidation="false" OnClick="btnBuscar_Click" ToolTip="Buscar">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                    </asp:LinkButton>
                                </div>
                            </div>

                            <!-- Subtle hidden / advanced filters when needed -->
                            <div style="display: none;">
                                <asp:DropDownList ID="ddlFiltroTipo" runat="server" />
                                <asp:DropDownList ID="ddlFiltroEstado" runat="server" />
                                <asp:TextBox ID="txtFiltroFecha" runat="server" />
                                <asp:Button ID="btnRestablecer" runat="server" OnClick="btnRestablecer_Click" />
                            </div>

                            <!-- Table matching image -->
                            <div style="overflow-x: auto;">
                                <asp:GridView ID="gvActividades" runat="server" AutoGenerateColumns="False"
                                    CssClass="data-table" GridLines="None" DataKeyNames="ActividadId" OnRowCommand="gvActividades_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="ActividadId" HeaderText="#" ItemStyle-Width="30px" />
                                        <asp:BoundField DataField="Titulo" HeaderText="Título" ItemStyle-Font-Bold="false" />
                                        <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                                        <asp:BoundField DataField="FechaInicio" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                                        <asp:BoundField DataField="Cupos" HeaderText="Cupos" />
                                        <asp:TemplateField HeaderText="Estado">
                                            <ItemTemplate><%# ObtenerBadgeEstado(Eval("Estado").ToString()) %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="110px">
                                            <ItemTemplate>
                                                <div class="table-actions-flex">
                                                    <!-- Eye (Ver) -->
                                                    <asp:LinkButton ID="btnVer" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("ActividadId") %>' CssClass="action-sq-btn btn-action-view" ToolTip="Ver detalle">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                                    </asp:LinkButton>
                                                    <!-- Pencil (Editar) -->
                                                    <asp:LinkButton ID="btnEditar" runat="server" CommandName="EditarActividad" CommandArgument='<%# Eval("ActividadId") %>' CssClass="action-sq-btn btn-action-edit" ToolTip="Editar" Visible='<%# PuedeGestionar() %>'>
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path></svg>
                                                    </asp:LinkButton>
                                                    <!-- Trash (Borrar) -->
                                                    <asp:LinkButton ID="btnEliminar" runat="server" CommandName="EliminarActividad" CommandArgument='<%# Eval("ActividadId") %>' CssClass="action-sq-btn btn-action-delete" ToolTip="Eliminar" OnClientClick="return confirm('¿Eliminar esta actividad?');" Visible='<%# PuedeGestionar() %>'>
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div style="padding: 20px; text-align: center; color: #64748b;">No existen actividades registradas.</div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>

                            <!-- Table Footer with Interactive Pagination -->
                            <div class="table-footer-bar">
                                <span id="paginationInfoText">Cargando registros...</span>
                                <asp:Label ID="lblTotalRegFooter" runat="server" style="display:none;" />
                                <div class="pagination-ctrls" id="paginationControls"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Placeholder if none selected -->
                    <asp:Panel ID="pnlSinSeleccion" runat="server" Visible="false" CssClass="app-card" style="padding: 16px; text-align: center; color: #64748b;">
                        Haga clic en el botón "Ver" (icono de ojo) de cualquier actividad para inspeccionar sus detalles.
                    </asp:Panel>

                    <!-- BOTTOM ROW: 3 CARDS MATCHING SCREENSHOT -->
                    <asp:Panel ID="pnlDetalleActividad" runat="server" CssClass="grid-bottom-3">
                        <!-- BOTTOM CARD 1: Detalles de la Actividad -->
                        <div class="app-card">
                            <div class="card-header-styled">
                                <div class="header-title-flex">
                                    <div class="header-circle-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                    </div>
                                    <span class="header-title-text">Detalles de la Actividad</span>
                                </div>
                            </div>
                            <div class="card-body-styled">
                                <div class="kv-row">
                                    <span class="kv-title">Título:</span>
                                    <span class="kv-value"><strong><asp:Label ID="lblDetalleTitulo" runat="server" Text="Taller de Programación Web" /></strong></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Tipo:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleTipo" runat="server" Text="Taller" /></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Descripción:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleDescripcion" runat="server" Text="Espacio práctico para reforzar conceptos de programación web con ASP.NET." /></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Fecha:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleFecha" runat="server" Text="15/05/2025 - 16/05/2025" /></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Hora:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleHora" runat="server" Text="08:00 - 12:00" /></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Modalidad:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleModalidad" runat="server" Text="Presencial" /></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Lugar:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleLugar" runat="server" Text="Laboratorio 3" /></span>
                                </div>
                                <div class="kv-row">
                                    <span class="kv-title">Cupos:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleCupos" runat="server" Text="30" /></span>
                                </div>
                                <div class="kv-row" style="border-bottom: none;">
                                    <span class="kv-title">Estado:</span>
                                    <span class="kv-value"><asp:Label ID="lblDetalleEstado" runat="server" Text="Activa" CssClass="badge-pill badge-activa" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- BOTTOM CARD 2: Estudiantes Inscritos (3) -->
                        <div class="app-card">
                            <div class="card-header-styled" style="justify-content: space-between;">
                                <div class="header-title-flex">
                                    <div class="header-circle-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><line x1="19" y1="8" x2="19" y2="14"></line><line x1="22" y1="11" x2="16" y2="11"></line></svg>
                                    </div>
                                    <span class="header-title-text">Estudiantes Inscritos (<asp:Label ID="lblConteoInscritos" runat="server" Text="3" />)</span>
                                </div>
                                <asp:Panel ID="pnlBotonInscribirOtro" runat="server">
                                    <button type="button" class="btn-green-sm" onclick="toggleEnrollBox()">+ Inscribir estudiante</button>
                                </asp:Panel>
                            </div>

                            <div class="card-body-styled" style="padding: 10px 14px;">
                                <!-- Expandable enroll form -->
                                <asp:Panel ID="pnlInscripcionManual" runat="server" style="display: none; margin-bottom: 10px; background: #f8fafc; padding: 8px; border-radius: 6px; border: 1px solid #e2e8f0;">
                                    <div style="display: flex; gap: 6px;">
                                        <asp:DropDownList ID="ddlEstudianteInscribir" runat="server" CssClass="form-select" />
                                        <asp:Button ID="btnInscribirEstudiante" runat="server" Text="Inscribir" CssClass="btn-green-sm" CausesValidation="false" OnClick="btnInscribirEstudiante_Click" />
                                    </div>
                                </asp:Panel>

                                <!-- Table of enrolled students -->
                                <asp:GridView ID="gvInscritos" runat="server" AutoGenerateColumns="False"
                                    CssClass="data-table" GridLines="None" OnRowCommand="gvInscritos_RowCommand">
                                    <Columns>
                                        <asp:TemplateField HeaderText="#" ItemStyle-Width="25px">
                                            <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="EstudianteNombre" HeaderText="Nombre" />
                                        <asp:BoundField DataField="EstudiantePrograma" HeaderText="Programa" />
                                        <asp:BoundField DataField="FechaInscripcion" HeaderText="Fecha inscripción" DataFormatString="{0:dd/MM/yyyy}" />
                                        <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="35px" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnCancelarInscripcion" runat="server" CommandName="CancelarInscripcion" CommandArgument='<%# Eval("InscripcionId") %>' CssClass="action-sq-btn btn-action-delete" ToolTip="Quitar estudiante" OnClientClick="return confirm('¿Cancelar inscripción de este estudiante?');" Visible='<%# PuedeCancelarInscripcion(Eval("UsuarioId")) %>'>
                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div style="padding: 14px; text-align: center; color: #64748b;">No hay estudiantes inscritos en esta actividad.</div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </div>

                        <!-- BOTTOM CARD 3: Vista de la Actividad (como la ve el estudiante) -->
                        <div class="app-card">
                            <div class="card-header-styled">
                                <div class="header-title-flex">
                                    <div class="header-circle-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    </div>
                                    <span class="header-title-text">Vista de la Actividad (como la ve el estudiante)</span>
                                </div>
                            </div>
                            <div class="card-body-styled">
                                <!-- Laptop desk image preview -->
                                <div class="preview-img-box">
                                    <img src="Content/images/laptop-preview.svg" alt="Laptop en escritorio" />
                                </div>

                                <div class="preview-title">
                                    <asp:Label ID="lblCardPreviewTitulo" runat="server" Text="Taller de Programación Web" />
                                </div>

                                <div class="preview-badges">
                                    <span class="badge-pill badge-tipo">
                                        👤 <asp:Label ID="lblCardPreviewTipo" runat="server" Text="Taller" />
                                    </span>
                                    <span class="badge-pill badge-activa">
                                        ✓ <asp:Label ID="lblCardPreviewEstado" runat="server" Text="Activa" />
                                    </span>
                                </div>

                                <div class="preview-meta-list">
                                    <div class="preview-meta-item">
                                        <span>📅</span>
                                        <span><asp:Label ID="lblCardPreviewFecha" runat="server" Text="15/05/2025 - 16/05/2025" /></span>
                                    </div>
                                    <div class="preview-meta-item">
                                        <span>🕒</span>
                                        <span><asp:Label ID="lblCardPreviewHora" runat="server" Text="08:00 - 12:00" /></span>
                                    </div>
                                    <div class="preview-meta-item">
                                        <span>📍</span>
                                        <span><asp:Label ID="lblCardPreviewLugar" runat="server" Text="Laboratorio 3" /></span>
                                    </div>
                                    <div class="preview-meta-item">
                                        <span>👥</span>
                                        <span>Cupos disponibles: <asp:Label ID="lblCardPreviewCupos" runat="server" Text="27 de 30" /></span>
                                    </div>
                                </div>

                                <p class="preview-desc">
                                    <asp:Label ID="lblCardPreviewDescripcion" runat="server" Text="Espacio práctico para reforzar conceptos de programación web con ASP.NET." />
                                </p>

                                <asp:Button ID="btnEstudianteInscribirme" runat="server" Text="Inscribirme" CssClass="btn-inscribirme" CausesValidation="false" OnClick="btnEstudianteInscribirme_Click" />
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- REVIEWS & RATINGS COLLAPSIBLE SECTION -->
                    <div class="app-card" style="margin-top: 10px;">
                        <div class="card-header-styled" style="cursor: pointer;" onclick="toggleReviews()">
                            <div class="header-title-flex">
                                <div class="header-circle-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                </div>
                                <span class="header-title-text">Reseñas y Valoraciones</span>
                                <span style="font-size: 11.5px; color: #64748b; margin-left: 6px;">(<asp:Label ID="lblPromedioResenas" runat="server" Text="Sin valoraciones" />)</span>
                            </div>
                            <span style="font-size: 12px; color: #2563eb;">▼ Desplegar / Ocultar</span>
                        </div>
                        <div id="reviewsBody" class="card-body-styled" style="display: none;">
                            <div style="display: flex; gap: 8px; margin-bottom: 12px;">
                                <asp:DropDownList ID="ddlCalificacion" runat="server" CssClass="form-select" style="width: 85px;">
                                    <asp:ListItem Text="5 ★" Value="5" Selected="True" />
                                    <asp:ListItem Text="4 ★" Value="4" />
                                    <asp:ListItem Text="3 ★" Value="3" />
                                    <asp:ListItem Text="2 ★" Value="2" />
                                    <asp:ListItem Text="1 ★" Value="1" />
                                </asp:DropDownList>
                                <asp:TextBox ID="txtComentarioResena" runat="server" CssClass="form-input" placeholder="Escribir opinión o reseña sobre la actividad..." MaxLength="500" />
                                <asp:Button ID="btnPublicarResena" runat="server" Text="Publicar" CssClass="btn-primary-blue" CausesValidation="false" OnClick="btnPublicarResena_Click" />
                            </div>

                            <asp:GridView ID="gvResenas" runat="server" AutoGenerateColumns="False"
                                CssClass="data-table" GridLines="None" OnRowCommand="gvResenas_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="UsuarioNombre" HeaderText="Autor" ItemStyle-Font-Bold="true" />
                                    <asp:BoundField DataField="CalificacionTexto" HeaderText="Calificación" />
                                    <asp:BoundField DataField="Comentario" HeaderText="Comentario" HtmlEncode="true" />
                                    <asp:TemplateField HeaderText="" ItemStyle-Width="30px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnBorrarResena" runat="server" CommandName="EliminarResena" CommandArgument='<%# Eval("ResenaId") %>' CssClass="action-sq-btn btn-action-delete" Visible='<%# EsAdministrador() || EsAutorResena(Eval("UsuarioId")) %>' ToolTip="Eliminar reseña">X</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div style="padding: 14px; text-align: center; color: #64748b;">No existen opiniones registradas aún.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </asp:Panel>

                <!-- SECTION 2: PANEL DE ADMINISTRADOR -->
                <asp:Panel ID="pnlSeccionAdmin" runat="server" Visible="false">
                    <div class="admin-cards-grid">
                        <!-- Subpanel 1: Gestión de Cuentas y Roles -->
                        <div class="app-card">
                            <div class="card-header-styled">
                                <span class="header-title-text">Cuentas y Asignación de Roles</span>
                                <span style="font-size: 11.5px; color: #64748b;">Registrados: <asp:Label ID="lblTotalUsuariosAdmin" runat="server" Text="0" /></span>
                            </div>
                            <div style="overflow-x: auto;">
                                <asp:GridView ID="gvAdminUsuarios" runat="server" AutoGenerateColumns="False"
                                    CssClass="data-table" GridLines="None" DataKeyNames="UsuarioId"
                                    OnRowCommand="gvAdminUsuarios_RowCommand" OnRowDataBound="gvAdminUsuarios_RowDataBound">
                                    <Columns>
                                        <asp:BoundField DataField="UsuarioId" HeaderText="#" ItemStyle-Width="25px" />
                                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" ItemStyle-Font-Bold="true" />
                                        <asp:BoundField DataField="Correo" HeaderText="Correo" />
                                        <asp:BoundField DataField="Programa" HeaderText="Programa" />
                                        <asp:TemplateField HeaderText="Rol">
                                            <ItemTemplate><%# ObtenerBadgeRol(Eval("Rol").ToString()) %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Asignar">
                                            <ItemTemplate>
                                                <div style="display: flex; gap: 4px; align-items: center;">
                                                    <asp:DropDownList ID="ddlCambioRol" runat="server" CssClass="form-select" style="width: 105px; padding: 3px 6px; font-size: 11px;">
                                                        <asp:ListItem Text="Estudiante" Value="Estudiante" />
                                                        <asp:ListItem Text="Docente" Value="Docente" />
                                                        <asp:ListItem Text="Administrador" Value="Administrador" />
                                                    </asp:DropDownList>
                                                    <asp:LinkButton ID="btnAplicarRol" runat="server" CommandName="CambiarRol" CommandArgument='<%# Eval("UsuarioId") %>' CssClass="action-sq-btn btn-action-view" CausesValidation="false" ToolTip="Guardar rol">✓</asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Acción">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEliminarUsuario" runat="server" CommandName="EliminarUsuario" CommandArgument='<%# Eval("UsuarioId") %>' CssClass="action-sq-btn btn-action-delete" CausesValidation="false" ToolTip="Eliminar cuenta" OnClientClick="return confirm('¿Eliminar usuario?');">✕</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div style="padding: 16px; text-align: center; color: #64748b;">No hay usuarios registrados.</div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </div>

                        <!-- Subpanel 2: Catálogo de Tipos -->
                        <div class="app-card">
                            <div class="card-header-styled">
                                <span class="header-title-text">Catálogo de Tipos de Actividad</span>
                            </div>
                            <div class="card-body-styled">
                                <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; margin-bottom: 12px;">
                                    <div style="font-weight: 600; font-size: 12px; margin-bottom: 6px; color: #1e293b;">Agregar Nueva Categoría</div>
                                    <div class="field-box" style="margin-bottom: 6px;">
                                        <label class="field-label">Nombre *</label>
                                        <asp:TextBox ID="txtNuevoTipoNombre" runat="server" CssClass="form-input" placeholder="Ej: Hackathon" MaxLength="50" />
                                    </div>
                                    <div class="field-box" style="margin-bottom: 8px;">
                                        <label class="field-label">Descripción</label>
                                        <asp:TextBox ID="txtNuevoTipoDescripcion" runat="server" CssClass="form-input" placeholder="Breve descripción..." MaxLength="250" />
                                    </div>
                                    <asp:Button ID="btnCrearTipoActividad" runat="server" Text="+ Guardar Categoría" CssClass="btn-primary-blue" CausesValidation="false" OnClick="btnCrearTipoActividad_Click" />
                                </div>

                                <div style="overflow-x: auto;">
                                    <asp:GridView ID="gvAdminTipos" runat="server" AutoGenerateColumns="False"
                                        CssClass="data-table" GridLines="None" DataKeyNames="TipoId" OnRowCommand="gvAdminTipos_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="TipoId" HeaderText="#" ItemStyle-Width="25px" />
                                            <asp:BoundField DataField="Nombre" HeaderText="Tipo" ItemStyle-Font-Bold="true" />
                                            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                                            <asp:TemplateField HeaderText="Acción" ItemStyle-Width="35px">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEliminarTipo" runat="server" CommandName="EliminarTipo" CommandArgument='<%# Eval("TipoId") %>' CssClass="action-sq-btn btn-action-delete" CausesValidation="false" OnClientClick="return confirm('¿Eliminar tipo?');">✕</asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div style="padding: 14px; text-align: center; color: #64748b;">No hay categorías registradas.</div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </main>
        </div>
    </form>

    <script>
        function toggleEnrollBox() {
            var box = document.getElementById('<%= pnlInscripcionManual.ClientID %>');
            if (box) {
                box.style.display = (box.style.display === 'none' || box.style.display === '') ? 'block' : 'none';
            }
        }

        function toggleReviews() {
            var r = document.getElementById('reviewsBody');
            if (r) {
                r.style.display = (r.style.display === 'none' || r.style.display === '') ? 'block' : 'none';
            }
        }

        // ==========================================
        // PAGINACIÓN INTERACTIVA DINÁMICA
        // ==========================================
        var currentPage = 1;
        var pageSize = 5;

        function getTableRows() {
            var table = document.getElementById('<%= gvActividades.ClientID %>');
            if (!table) return [];
            var allRows = Array.from(table.querySelectorAll('tbody > tr, tr'));
            // Filtrar sólo filas de datos válidas (excluir cabecera th y mensajes de tabla vacía)
            return allRows.filter(function (r) {
                return r.querySelector('td') && r.cells.length > 2;
            });
        }

        function updatePagination(filteredRows) {
            var allRows = getTableRows();
            var rows = filteredRows || allRows;
            var totalRows = rows.length;
            var totalPages = Math.max(1, Math.ceil(totalRows / pageSize));

            if (currentPage > totalPages) currentPage = totalPages;
            if (currentPage < 1) currentPage = 1;

            var startIdx = (currentPage - 1) * pageSize;
            var endIdx = Math.min(startIdx + pageSize, totalRows);

            // Ocultar todas las filas primero
            allRows.forEach(function (r) { r.style.display = 'none'; });

            // Mostrar sólo el rango de la página actual
            rows.forEach(function (row, idx) {
                if (idx >= startIdx && idx < endIdx) {
                    row.style.display = '';
                }
            });

            // Actualizar texto informativo: "Mostrando X a Y de Z registros"
            var infoSpan = document.getElementById('paginationInfoText');
            if (infoSpan) {
                if (totalRows === 0) {
                    infoSpan.innerText = 'Mostrando 0 registros';
                } else {
                    infoSpan.innerText = 'Mostrando ' + (startIdx + 1) + ' a ' + endIdx + ' de ' + totalRows + ' registros';
                }
            }

            // Renderizar botones de paginación interactivos
            var container = document.getElementById('paginationControls');
            if (!container) return;
            container.innerHTML = '';

            function createBtn(html, title, isDisabled, isActive, onClick) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'page-num' + (isActive ? ' active' : '') + (isDisabled ? ' disabled' : '');
                btn.innerHTML = html;
                btn.title = title || '';
                if (isDisabled) {
                    btn.disabled = true;
                } else {
                    btn.onclick = onClick;
                }
                return btn;
            }

            // « Primera página
            container.appendChild(createBtn('&laquo;', 'Primera página', currentPage === 1, false, function () {
                currentPage = 1;
                updatePagination(filteredRows);
            }));

            // ‹ Página anterior
            container.appendChild(createBtn('&lsaquo;', 'Página anterior', currentPage === 1, false, function () {
                currentPage = Math.max(1, currentPage - 1);
                updatePagination(filteredRows);
            }));

            // Botones numéricos 1, 2, 3...
            for (var p = 1; p <= totalPages; p++) {
                (function (pNum) {
                    container.appendChild(createBtn(pNum.toString(), 'Página ' + pNum, false, pNum === currentPage, function () {
                        currentPage = pNum;
                        updatePagination(filteredRows);
                    }));
                })(p);
            }

            // › Página siguiente
            container.appendChild(createBtn('&rsaquo;', 'Página siguiente', currentPage === totalPages, false, function () {
                currentPage = Math.min(totalPages, currentPage + 1);
                updatePagination(filteredRows);
            }));

            // » Última página
            container.appendChild(createBtn('&raquo;', 'Última página', currentPage === totalPages, false, function () {
                currentPage = totalPages;
                updatePagination(filteredRows);
            }));
        }

        function filterTableBySearch() {
            var txt = document.getElementById('<%= txtBuscar.ClientID %>');
            var query = (txt ? txt.value : '').toLowerCase().trim();
            var allRows = getTableRows();

            if (!query) {
                currentPage = 1;
                updatePagination();
                return;
            }

            var matchingRows = allRows.filter(function (row) {
                return row.innerText.toLowerCase().indexOf(query) >= 0;
            });

            currentPage = 1;
            updatePagination(matchingRows);
        }

        document.addEventListener('DOMContentLoaded', function () {
            updatePagination();

            var searchInput = document.getElementById('<%= txtBuscar.ClientID %>');
            if (searchInput) {
                searchInput.addEventListener('input', filterTableBySearch);
                searchInput.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        filterTableBySearch();
                        return false;
                    }
                });
            }
        });
    </script>
</body>
</html>
