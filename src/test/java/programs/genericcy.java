package programs;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.Test;

import java.util.List;


public class genericcy {



//    public void launchApp(WebDriver driver) {
//        driver.get("https://example.com");


    public static <T extends WebDriver> T openUrl(T driver, String url) {
        driver.get(url);
        return driver;
    }

    public <T extends WebDriver> T maximixe(T driver){
        driver.manage().window().maximize();
        return driver;
   }


@Test
    public void hello(){
   maximixe(openUrl(new ChromeDriver(), "https://example.com"));

//        launchApp(new ChromeDriver());

    }

    @Test
        public void addNumber(List<? super Integer> list) {
            list.add(10);
        }



}