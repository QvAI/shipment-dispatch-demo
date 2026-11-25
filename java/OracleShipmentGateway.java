import java.sql.SQLException;
import java.sql.Types;
import javax.sql.DataSource;

record OracleShipmentGateway(DataSource dataSource) implements ShipmentGateway {
    @Override
    public long submit(String requestKey, String destination) throws SQLException {
        try (var connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);
            try (var statement = connection.prepareCall("{call Shipment_Api.Submit(?, ?, ?)}")) {
                statement.setString(1, requestKey);
                statement.setString(2, destination);
                statement.registerOutParameter(3, Types.NUMERIC);
                statement.execute();
                long shipmentId = statement.getLong(3);
                connection.commit();
                return shipmentId;
            } catch (SQLException error) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    error.addSuppressed(rollbackError);
                }
                throw error;
            }
        }
    }
}
