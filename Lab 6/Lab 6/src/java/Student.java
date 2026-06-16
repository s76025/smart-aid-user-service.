/**
 *
 * @author Acer
 */
package lab6.com;

public class Student {

    private String stuid;
    private String stuname;
    private String stuprogram;
    private String address;

    public Student() {
    }

    public String getStuid() {
        return stuid;
    }

    public void setStuid(String stuid) {

        if (stuid.matches("[A-Z]{2}[0-9]{5}")) {
            this.stuid = stuid;
        } else {
            throw new IllegalArgumentException(
                    "Student ID must follow format like UK12345"
            );
        }
    }

    public String getStuname() {
        return stuname;
    }

    public void setStuname(String stuname) {
        this.stuname = stuname;
    }

    public String getStuprogram() {
        return stuprogram;
    }

    public void setStuprogram(String stuprogram) {
        this.stuprogram = stuprogram;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
