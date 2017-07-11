using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    // http://blog.vuscode.com/malovicn/archive/2012/09/20/task-whileall.aspx
    public static class TaskExtensions
    {
        public static async Task<IList<T>> WhileAll<T>(this IList<Task<T>> tasks, IProgress<T> progress)
        {
            var result = new List<T>(tasks.Count);
            var done = new List<Task<T>>(tasks);
            while (done.Count > 0)
            {
                await Task.WhenAny(tasks);
                var spinning = new List<Task<T>>(done.Count - 1);
                for (int i = 0; i < done.Count; i++)
                {
                    if (done[i].IsCompleted)
                    {
                        result.Add(done[i].Result);
                        progress.Report(done[i].Result);
                    }
                    else
                    {
                        spinning.Add(done[i]);
                    }
                }

                done = spinning;
            }

            return result;
        }

        //http://blogs.msdn.com/b/pfxteam/archive/2012/08/02/processing-tasks-as-they-complete.aspx
        public static Task<Task<T>>[] Interleaved<T>(this IEnumerable<Task<T>> tasks)
        {
            var inputTasks = tasks.ToList();

            var buckets = new TaskCompletionSource<Task<T>>[inputTasks.Count];
            var results = new Task<Task<T>>[buckets.Length];
            for (int i = 0; i < buckets.Length; i++)
            {
                buckets[i] = new TaskCompletionSource<Task<T>>();
                results[i] = buckets[i].Task;
            }

            int nextTaskIndex = -1;
            Action<Task<T>> continuation = completed =>
            {
                var bucket = buckets[Interlocked.Increment(ref nextTaskIndex)];
                bucket.TrySetResult(completed);
            };

            foreach (var inputTask in inputTasks)
                inputTask.ContinueWith(continuation, CancellationToken.None, TaskContinuationOptions.ExecuteSynchronously, TaskScheduler.Default);

            return results;
        }
    }

    // http://code.jonwagner.com/2012/09/06/best-practices-for-c-asyncawait/
    public static class Empty<T>
    {
        public static Task<T> Task { get { return _task; } }

        private static readonly Task<T> _task = System.Threading.Tasks.Task.FromResult(default(T));
    }
}
