# 3. DI(Dependency Injection) 1

### 3-1. 스프링을 이용한 객체 생성과 조립

2절에서 살펴본 예제는 스프링의 특징(사용법)이 적용되지 않은 프로젝트였다. 이번 시간에는 스프링의 특징(사용법)을 적용하여 스프링과 좀 더 친근해 질 수 있는 시간을 갖도록 한다.

* 스프링의 특징을 사용하지 않은 프로젝트

  ```java
  public static void main(String[] args) {
    MyCalculator myCalculator = new MyCalculator();
    myCalculator.setCalculator(new Calculator());
    
    myCalculator.setFirstNum(10);
    myCalculator.setSecondNum(12);
    
    myCalculator.add();
    myCalculator.sub();
    myCalculator.mul();
    myCalculator.div();
  }
  ```

* 스프링의 특징이 적용된 프로젝트

  ```java
  public static void main(String[] args) {
    String configLocation = "classpath:applicationCTX.xml";
    AbstractApplicationContext ctx = new GenericXmlApplicationContext(configLocation);
    MyCalculator myCalculator = ctx.getBean("myCalculator", MyCalculator.class);
    
    myCalculator.add();
    myCalculator.sub();
    myCalculator.mul();
    myCalculator.div();
  }
  ```

### 3-2. 스프링 설정 파일의 이해

스프링을 학습하는데 첫 단계는 스프링 설정 파일의 이해이다.

* xml파일을 spring config 파일 이라고 한다.
* beans로 시작해서 끝난다.


* applicationCTX.xml
  * id - 변수 설정
  * class - 객체 생성(full name 입력)
  * property - 필드 설정
  * ref - 객체 참조
  * value는 Class의 setter가 정의 되어 있어야 사용 가능하다.
    * 규칙에 맞게 정의되어있어야 한다.
    * ex) first의 setter는 setFirst이고, 만약 setFirstNum이면 변수는 firstNum일 것이다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.springframework.org/schema/beans http://springframework.org/schema/beans/spring-beans.xsd">
  
  <bean id="calculator" class="com.java.ex.Calculator"/>
  
  <bean id="myCalculator" class="com.java.ex.MyCalculator">
    <property name="calculator">
      <ref bean="calculator"/>
    </property>
    <property name="first" value="10"/>
    <property name="second" value="2"/>
  </bean>
</beans>
```

  

# 4. DI(Dependency Injection) 2

* 실습 코드 repo : [저장소](https://github.com/namjunemy/spring_for_junior_developer/tree/master/spring_4_1_ex1_springex)

### 4-1. 스프링 프로퍼티 설정

* 스프링 프로퍼티 설정에 대한 기본적인 사항들을 학습한다. 기본적이라고 하지만, 가장 많이 쓰이고 꼭 알고 있어야 한다.

* MyInfo.java

  ```java
  public class MyInfo {
    private String name;
    private double height;
    private double weight;
    private ArrayList<String> hobbys;
    private BMICalculator bmiCalculator;
    
    public void setBmiCalculator(BMICalculator bmiCalculator) {
      this.bmiCalculator = bmiCalculator;
    }
    
    public void setName(String name) {
      this.name = name;
    }
    
    public void setHeight(double height) {
      this.height = height;
    }
    
    public void setWeight(double weight) {
      this.weight = weight;
    }
    
    public void setHobbys(ArrayList<String> hobbys) {
      this.hobbys = hobbys;
    }
  }
  ```

* 스프링 프로퍼티 파일

  * MyInfo의 setter가 존재하기 때문에 아래의 설정을 사용할 수 있다.
  * 각 property의 value에 기초 데이터를 설정할 수 있다.

  ```xml
  ...
  <bean id="myInfo" class="com.java.ex.MyInfo">
    <property name="name">
      <value>홍길동</value>  //기초데이터
    </property>
    <property name="height">
      <value>187</value>
    </property>
    <property name="weight">
      <value>85</value>
    </property>
    <property name="hobbys">	//List타입
      <list>
        <value>수영</value>
        <value>요리</value>
        <value>독서</value>
      </list>
    </property>
    <property name="bmiCalculator">
      <ref bean="bmiCalculator"/>  //다른 빈객체 참조
    </property>
  </bean>
  ...
  ```

* MainClass.java

  ```java
  import org.springframework.context.support.AbstractApplicationContext;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class MainClass {
    public static void main(String[] args) {
      String configLocation = "classpath:applicationCTX.xml";
      //스프링 컨테이너 생성
      AbstractApplicationContext ctx = new GenericXmlApplicationContext(configLocation);
      
      //스프링 컨테이너에서 컴포넌트를 가져옴
      MyInfo myInfo = ctx.getBean("myInfo", MyInfo.class);
      myInfo.getInfo();
      ctx.close();
    }
  }
  ```

  

### 4-2. 스프링 컨테이너의 이해

* GenericXmlApplicationContext를 이용하여 스프링 컨테이너를 생성하고 아래와 같이 컴포넌트를 사용한다.


* MainClass.java

```java
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

public class MainClass {
  public static void main(String[] args) {
    String configLocation = "classpath:applicationCTX.xml";
    //스프링 컨테이너 생성
    AbstractApplicationContext ctx = new GenericXmlApplicationContext(configLocation);
    
    //스프링 컨테이너에서 컴포넌트를 가져옴
    MyInfo myInfo = ctx.getBean("myInfo", MyInfo.class);
    myInfo.getInfo();
    ctx.close();
  }
}
```

