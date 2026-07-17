package filter;

import bean.Usuario;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/admin/*",
    "/usuario/*",
    "/tecnico/*"
})
public class RolFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Usuario usuario = null;

        if (session != null) {
            usuario = (Usuario) session.getAttribute("usuario");
        }

        if (usuario == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String uri = req.getRequestURI();
        String rol = usuario.getNombreRol();

        if (uri.contains("/admin/") && !rol.equals("ADMIN")) {
            res.sendRedirect(req.getContextPath() + "/accesoDenegado.jsp");
            return;
        }

        if (uri.contains("/usuario/") && !rol.equals("USUARIO")) {
            res.sendRedirect(req.getContextPath() + "/accesoDenegado.jsp");
            return;
        }

        if (uri.contains("/tecnico/") && !rol.equals("TECNICO")) {
            res.sendRedirect(req.getContextPath() + "/accesoDenegado.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}