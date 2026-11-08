using System.Collections.Generic;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public interface IResenaRepository
    {
        List<ResenaDto> ListarPorActividad(int actividadId);
        bool ExisteResena(int actividadId, int usuarioId);
        int Insertar(ResenaDto resena);
        bool Eliminar(int resenaId);
    }
}
