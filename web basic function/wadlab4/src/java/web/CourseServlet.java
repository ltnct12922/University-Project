/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CourseDAO;
import model.Course;
import dao.UserDAO;
import model.User;
/**
 *
 * @author acer
 */
@WebServlet("/register")
public class CourseServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private CourseDAO courseDAO;
    private UserDAO userDAO;

    public void init() {
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ID = request.getParameter("ID");
        String Cname = request.getParameter("cname");


        Course course = new Course();
        course.setID(ID);
        course.setCname(Cname);

        try {
            courseDAO.registerCourse(course);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        String ID2 = request.getParameter("ID2");
        String fullName = request.getParameter("Fullname");


        User user = new User();
        user.setID(ID2);
        user.setFullname(fullName);

        try {
            userDAO.registerUser(user);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        response.sendRedirect("homepage.jsp");
        
    }
        
        
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
       
        
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
