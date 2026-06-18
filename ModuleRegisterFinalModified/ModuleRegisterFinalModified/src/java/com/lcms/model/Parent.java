package com.lcms.model;

public class Parent {

    private int    id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private int    age;
    private String occupation;
    private String address;
    private String ic;

    public Parent() {}

    public Parent(String username, String password, String email, String phone,
                  int age, String occupation, String address, String ic) {
        this.username   = username;
        this.password   = password;
        this.email      = email;
        this.phone      = phone;
        this.age        = age;
        this.occupation = occupation;
        this.address    = address;
        this.ic         = ic;
    }

    public int    getId()                        { return id; }
    public void   setId(int id)                  { this.id = id; }
    public String getUsername()                  { return username; }
    public void   setUsername(String username)   { this.username = username; }
    public String getPassword()                  { return password; }
    public void   setPassword(String password)   { this.password = password; }
    public String getEmail()                     { return email; }
    public void   setEmail(String email)         { this.email = email; }
    public String getPhone()                     { return phone; }
    public void   setPhone(String phone)         { this.phone = phone; }
    public int    getAge()                       { return age; }
    public void   setAge(int age)                { this.age = age; }
    public String getOccupation()                { return occupation; }
    public void   setOccupation(String o)        { this.occupation = o; }
    public String getAddress()                   { return address; }
    public void   setAddress(String address)     { this.address = address; }
    public String getIc()                        { return ic; }
    public void   setIc(String ic)               { this.ic = ic; }
}