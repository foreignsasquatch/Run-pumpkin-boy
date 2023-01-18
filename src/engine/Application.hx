package engine;

import cpp.Callable;
import emscripten.Emscripten;



class Application {
  public static var width:Int;
  public static var height:Int;
  public static var title:String;
  public static var currentState:State;
  static var timeCounter = 0.0;
  static var timeStep = 1 / 60;
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

      #if wasm
      Emscripten.setMainLoop(Callable.fromStaticFunction(update), 60, 1);
      #else
      while(!Rl.windowShouldClose()) {
        update();
      }
      #end

      Rl.closeWindow();

      #if HXCPP_PROFILER
      Profiler.stop();
      #end
  }

  static function update() {
        // Fixed step
        timeCounter += Rl.getFrameTime();
        while(timeCounter > timeStep) {
          currentState.step();
          timeCounter -= timeStep;
        }

        Rl.beginDrawing();
        {
          Rl.clearBackground(Rl.Color.create(0, 100, 125, 255));

          currentState.draw();
        }
        Rl.endDrawing();
  }
}
