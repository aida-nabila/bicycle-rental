package process;

public class Rental {
    private int id;
    private String bicycleType;
    private String tagNo;
    private int rentalHours;
    private String rentalDate;
    private String rentalTime;
    private String createdAt;
    private double amount;
    private String paymentDate;
    private String rentalStatus;
    private double penalty;

    public Rental(int id, String bicycleType, String tagNo, int rentalHours, String rentalDate, String rentalTime, 
                  String createdAt, double amount, String paymentDate, String rentalStatus, double penalty) {
        this.id = id;
        this.bicycleType = bicycleType;
        this.tagNo = tagNo;
        this.rentalHours = rentalHours;
        this.rentalDate = rentalDate;
        this.rentalTime = rentalTime;
        this.createdAt = createdAt;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.rentalStatus = rentalStatus;
        this.penalty = penalty;
    }

    public int getId() { return id; }
    public String getBicycleType() { return bicycleType; }
    public String getTagNo() { return tagNo; }
    public int getRentalHours() { return rentalHours; }
    public String getRentalDate() { return rentalDate; }
    public String getRentalTime() { return rentalTime; }
    public String getCreatedAt() { return createdAt; }
    public double getAmount() { return amount; }
    public String getPaymentDate() { return paymentDate; }
    public String getRentalStatus() { return rentalStatus; }
    public double getPenalty() { return penalty; }

    // Setter for status
    public void setRentalStatus(String rentalStatus) {
        this.rentalStatus = rentalStatus;
    }
}