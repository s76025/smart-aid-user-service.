package com.lcms.model;

public class Teacher {
    private int    id;
    private String username;
    private String password;
    private String fullName;
    private String icNumber;
    private String email;
    private String phone;
    private String qualification;
    private String teachingExperience;
    private String subject;

    public Teacher() {}

    public Teacher(String username, String password, String fullName,
                   String icNumber, String email, String phone,
                   String qualification, String teachingExperience, String subject) {
        this.username          = username;
        this.password          = password;
        this.fullName          = fullName;
        this.icNumber          = icNumber;
        this.email             = email;
        this.phone             = phone;
        this.qualification     = qualification;
        this.teachingExperience = teachingExperience;
        this.subject           = subject;
    }

    public int    getId()                               { return id; }
    public void   setId(int id)                         { this.id = id; }
    public String getUsername()                         { return username; }
    public void   setUsername(String u)                 { this.username = u; }
    public String getPassword()                         { return password; }
    public void   setPassword(String p)                 { this.password = p; }
    public String getFullName()                         { return fullName; }
    public void   setFullName(String f)                 { this.fullName = f; }
    public String getIcNumber()                         { return icNumber; }
    public void   setIcNumber(String ic)                { this.icNumber = ic; }
    public String getEmail()                            { return email; }
    public void   setEmail(String e)                    { this.email = e; }
    public String getPhone()                            { return phone; }
    public void   setPhone(String p)                    { this.phone = p; }
    public String getQualification()                    { return qualification; }
    public void   setQualification(String q)            { this.qualification = q; }
    public String getTeachingExperience()               { return teachingExperience; }
    public void   setTeachingExperience(String te)      { this.teachingExperience = te; }
    public String getSubject()                          { return subject; }
    public void   setSubject(String s)                  { this.subject = s; }
}
