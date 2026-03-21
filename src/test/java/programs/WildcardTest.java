package programs;

import org.testng.annotations.Test;
import java.util.ArrayList;
import java.util.List;

public class WildcardTest {

    public void getNumber(List<? extends Integer> list) {
        list.get(0);
    }

    public void addNumber(List<? super Integer> list) {
        list.add(10);
    }


    @Test
    public void testgetNumber() {
        List<Integer> list = new ArrayList<>();
        list.add(2);
        getNumber(list);

        System.out.println(list); // [10]
    }

    @Test
    public void testAddNumber() {
        List<Object> list = new ArrayList<>();
        addNumber(list);

        System.out.println(list); // [10]
    }

}