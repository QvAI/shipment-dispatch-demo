import java.sql.SQLException;
import java.sql.SQLTransientException;

record ShipmentClient(ShipmentGateway gateway) {
    long submit(String requestKey, String destination) throws SQLException {
        try {
            return gateway.submit(requestKey, destination);
        } catch (SQLTransientException retryable) {
            return gateway.submit(requestKey, destination);
        }
    }
}
