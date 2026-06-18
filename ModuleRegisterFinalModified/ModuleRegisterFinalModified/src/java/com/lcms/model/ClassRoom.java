package com.lcms.model;

import java.util.List;

public class ClassRoom {

    private int          id;
    private String       className;
    private String       classCode;
    private int          maxKids;
    private String       teacher;
    private String       classDays;
    private List<Integer> studentIds;   // ← NEW

    public ClassRoom() {}

    public ClassRoom(String className, String classCode, int maxKids,
                     String teacher, String classDays) {
        this.className = className;
        this.classCode = classCode;
        this.maxKids   = maxKids;
        this.teacher   = teacher;
        this.classDays = classDays;
    }

    public int           getId()                           { return id; }
    public void          setId(int id)                     { this.id = id; }
    public String        getClassName()                    { return className; }
    public void          setClassName(String className)    { this.className = className; }
    public String        getClassCode()                    { return classCode; }
    public void          setClassCode(String classCode)    { this.classCode = classCode; }
    public int           getMaxKids()                      { return maxKids; }
    public void          setMaxKids(int maxKids)           { this.maxKids = maxKids; }
    public String        getTeacher()                      { return teacher; }
    public void          setTeacher(String teacher)        { this.teacher = teacher; }
    public String        getClassDays()                    { return classDays; }
    public void          setClassDays(String classDays)    { this.classDays = classDays; }
    public List<Integer> getStudentIds()                   { return studentIds; }
    public void          setStudentIds(List<Integer> ids)  { this.studentIds = ids; }
}