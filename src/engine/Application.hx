package engine;

import cpp.vm.Profiler;

class Application {
  public static var width:Int;
  public static var height:Int;
  public static var title:String;
  public static var currentState:State;

  public function new(width:Int, height:Int, title:String, state:State, targetFps:Int = 60) {
      Application.width = width;
      Application.height = height;
      Application.title = title;
      currentState = state;

      Rl.initWindow(Application.width, Application.height, Application.title);
      Rl.setTargetFPS(targetFps);

      #if HXCPP_PROFILER
        Profiler.start("profiler_out");
      #end

      state.init();

      var timeCounter = 0.0;
      var timeStep = 1 / targetFps;

      while(!Rl.windowShouldClose()) {
        // Fixed step
        timeCounter += Rl.getFrameTime();
        while(timeCounter > timeStep) {
          state.step();
          timeCounter -= timeStep;
        }

        Rl.beginDrawing();
        {
          Rl.clearBackground(Rl.Color.create(0, 100, 125, 255));

          state.draw();
        }
        Rl.endDrawing();
      }

      Rl.closeWindow();

      #if HXCPP_PROFILER
      Profiler.stop();
      #end
  }
}
