import java.sql.SQLTimeoutException;
import java.util.ArrayList;
import java.util.List;

public final class ShipmentRetryContract {
    private record Request(String key, String destination) {}

    public static void main(String[] args) throws Exception {
        var calls = new ArrayList<Request>();
        var client = new ShipmentClient((key, destination) -> {
            calls.add(new Request(key, destination));
            if (calls.size() == 1) {
                throw new SQLTimeoutException("Simulator: reply was lost");
            }
            return 101L;
        });
        var request = new Request("REQ-101", "DEB");
        long id = client.submit(request.key(), request.destination());
        if (id != 101L || !calls.equals(List.of(request, request))) {
            throw new AssertionError("Expected two attempts with the same key and payload: " + calls);
        }
        System.out.println("JAVA FIXTURE / both attempts carried REQ-101 and DEB");
    }
}
