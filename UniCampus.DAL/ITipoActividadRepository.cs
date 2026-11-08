using System.Collections.Generic;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public interface ITipoActividadRepository
    {
        List<TipoActividadDto> ListarTodos();
        int Insertar(TipoActividadDto tipo);
        bool Eliminar(int tipoId);
        bool Existe(string nombre);
    }
}
