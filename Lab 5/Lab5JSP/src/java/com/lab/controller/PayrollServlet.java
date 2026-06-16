package com.lab.controller;

import com.lab.bean.Employee;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Name : Noor Izza Hazira bt Norddin
 * Matric no : S76025
 */
public class PayrollServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Employee> list = new ArrayList<>();

        Employee e1 = new Employee();
        e1.setEmpId("E001");
        e1.setName("Ali");
        e1.setDepartment("IT");
        e1.setBasicSalary(3500);

        Employee e2 = new Employee();
        e2.setEmpId("E002");
        e2.setName("Siti");
        e2.setDepartment("Finance");
        e2.setBasicSalary(2800);

        Employee e3 = new Employee();
        e3.setEmpId("E003");
        e3.setName("Kumar");
        e3.setDepartment("HR");
        e3.setBasicSalary(4000);

        Employee e4 = new Employee();
        e4.setEmpId("E004");
        e4.setName("John");
        e4.setDepartment("Marketing");
        e4.setBasicSalary(2500);

        Employee e5 = new Employee();
        e5.setEmpId("E005");
        e5.setName("Nurul");
        e5.setDepartment("Admin");
        e5.setBasicSalary(3200);

        list.add(e1);
        list.add(e2);
        list.add(e3);
        list.add(e4);
        list.add(e5);

        request.setAttribute("employeeList", list);

        RequestDispatcher rd = request.getRequestDispatcher("payroll_view.jsp");
        rd.forward(request, response);
    }
}
