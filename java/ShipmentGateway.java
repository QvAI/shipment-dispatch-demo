import java.sql.SQLException;

interface ShipmentGateway {
    long submit(String requestKey, String destination) throws SQLException;
}
