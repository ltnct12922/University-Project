/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;


/**
 * JavaBean class used in jsp action tags.
 * @author Ramesh Fadatare
 */
public class User {
    /**
     * 
     */
    private String ID;
    private String Fullname;

    public String getID() {
        return ID;
    }
    public void setID(String ID) {
        this.ID = ID;
    }
    public String getFullname() {
        return Fullname;
    }
    public void setFullname(String Fullname) {
        this.Fullname = Fullname;
    }
}