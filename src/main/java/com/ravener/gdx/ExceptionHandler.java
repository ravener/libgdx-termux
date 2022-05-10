package com.ravener.gdx;

import java.lang.Thread.UncaughtExceptionHandler;
import java.io.StringWriter;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class ExceptionHandler implements UncaughtExceptionHandler {
  private UncaughtExceptionHandler defaultUEH;
  private String localPath;
  private DateFormat fmt;

  public ExceptionHandler(String localPath) {
    this.localPath = localPath;
    this.defaultUEH = Thread.getDefaultUncaughtExceptionHandler();
    this.fmt = new SimpleDateFormat("yyyy-MM-dd-HH-mm");
  }
  
  public void uncaughtException(Thread t, Throwable e) {
    String timestamp = this.fmt.format(new Date());   
    final Writer result = new StringWriter();
    final PrintWriter printWriter = new PrintWriter(result);
    e.printStackTrace(printWriter);
    String stacktrace = result.toString();
    printWriter.close();
    String filename = "log-" + timestamp + ".txt";

    if (localPath != null) {
      writeToFile(stacktrace, filename);
    }

    defaultUEH.uncaughtException(t, e);
  }
  
  private void writeToFile(String stacktrace, String filename) {
    try {
      BufferedWriter bos = new BufferedWriter(new FileWriter(localPath + "/" + filename));
      bos.write(stacktrace);
      bos.flush();
      bos.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
