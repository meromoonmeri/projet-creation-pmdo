using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using UndertaleModLib;
using UndertaleModLib.Models;
using Newtonsoft.Json;

public static class NoNameVillageExtractor
{
    sealed class RefEq : IEqualityComparer<object>
    {
        public new bool Equals(object x, object y) { return Object.ReferenceEquals(x, y); }
        public int GetHashCode(object x) { return System.Runtime.CompilerServices.RuntimeHelpers.GetHashCode(x); }
    }
    sealed class ResourceRef
    {
        public string Category; public int Index; public string Name;
    }
    static readonly RefEq RefComparer = new RefEq();
    static readonly Dictionary<object, ResourceRef> Resources = new Dictionary<object, ResourceRef>(RefComparer);
    static readonly Dictionary<object, string> Seen = new Dictionary<object, string>(RefComparer);
    static string OutputRoot;
    static string BlobRoot;
    static int ErrorCount;
    static int BinaryCount;
    static long BinaryBytes;

    public static int Main(string[] args)
    {
        if (args.Length < 2) { Console.Error.WriteLine("usage: extractor data.win output-directory"); return 2; }
        OutputRoot = args[1]; BlobRoot = Path.Combine(OutputRoot, "blobs");
        Directory.CreateDirectory(OutputRoot); Directory.CreateDirectory(BlobRoot); Directory.CreateDirectory(Path.Combine(OutputRoot, "inventory"));
        Console.WriteLine("No Name Village exhaustive extractor: loading " + args[0]);
        UndertaleData data;
        using (FileStream fs = File.OpenRead(args[0])) data = UndertaleIO.Read(fs);
        Console.WriteLine("Loaded: " + data.Rooms.Count + " rooms, " + data.Sprites.Count + " sprites, " + data.GameObjects.Count + " objects");

        List<PropertyInfo> listProps = data.AllListProperties.Where(p => p.GetIndexParameters().Length == 0).OrderBy(p => p.Name, StringComparer.Ordinal).ToList();
        foreach (PropertyInfo prop in listProps)
        {
            IList list = null; try { list = prop.GetValue(data, null) as IList; } catch { }
            if (list == null) continue;
            for (int i = 0; i < list.Count; i++)
            {
                object item = list[i]; if (item == null || Resources.ContainsKey(item)) continue;
                Resources[item] = new ResourceRef { Category = prop.Name, Index = i, Name = GetResourceName(item) };
            }
        }

        Dictionary<string, int> counts = new Dictionary<string, int>(StringComparer.Ordinal);
        WriteSingleObject("GeneralInfo", data.GeneralInfo);
        WriteSingleObject("Options", data.Options);
        WriteSingleObject("Language", data.Language);
        WriteSingleObject("Tags", data.Tags);
        WriteSingleObject("FeatureFlags", data.FeatureFlags);

        foreach (PropertyInfo prop in listProps)
        {
            IList list = null; try { list = prop.GetValue(data, null) as IList; } catch (Exception ex) { WriteErrorFile(prop.Name, ex); continue; }
            if (list == null) continue;
            counts[prop.Name] = list.Count;
            Console.WriteLine("Inventory " + prop.Name + ": " + list.Count);
            WriteList(prop.Name, list);
        }

        ExportAudio(data);
        WriteMetadata(data, counts);
        Console.WriteLine("Extraction complete; binary blobs=" + BinaryCount + ", bytes=" + BinaryBytes + ", errors=" + ErrorCount);
        return ErrorCount == 0 ? 0 : 3;
    }

    static void WriteSingleObject(string name, object value)
    {
        string path = Path.Combine(OutputRoot, "inventory", name + ".json");
        using (StreamWriter sw = new StreamWriter(path, false, new UTF8Encoding(false)))
        using (JsonTextWriter jw = new JsonTextWriter(sw) { Formatting = Formatting.Indented })
        { Seen.Clear(); WriteAny(jw, value, "$", value, 0); }
    }

    static void WriteList(string name, IList list)
    {
        string path = Path.Combine(OutputRoot, "inventory", name + ".json");
        using (StreamWriter sw = new StreamWriter(path, false, new UTF8Encoding(false)))
        using (JsonTextWriter jw = new JsonTextWriter(sw) { Formatting = Formatting.Indented })
        {
            jw.WriteStartArray();
            for (int i = 0; i < list.Count; i++)
            {
                object root = list[i]; Seen.Clear(); WriteAny(jw, root, "$[" + i + "]", root, 0);
            }
            jw.WriteEndArray();
        }
    }

    static void WriteAny(JsonTextWriter w, object value, string path, object root, int depth)
    {
        if (value == null) { w.WriteNull(); return; }
        if (depth > 80) { w.WriteStartObject(); w.WritePropertyName("$unverified"); w.WriteValue("MAX_DEPTH"); w.WriteEndObject(); return; }
        Type t = value.GetType();
        if (value is UndertaleString) { w.WriteValue(((UndertaleString)value).Content); return; }
        if (value is string) { w.WriteValue((string)value); return; }
        if (value is char) { w.WriteValue(value.ToString()); return; }
        if (value is bool) { w.WriteValue((bool)value); return; }
        if (value is byte) { w.WriteValue((byte)value); return; }
        if (value is sbyte) { w.WriteValue((sbyte)value); return; }
        if (value is short) { w.WriteValue((short)value); return; }
        if (value is ushort) { w.WriteValue((ushort)value); return; }
        if (value is int) { w.WriteValue((int)value); return; }
        if (value is uint) { w.WriteValue((long)(uint)value); return; }
        if (value is long) { w.WriteValue((long)value); return; }
        if (value is ulong) { w.WriteValue(((ulong)value).ToString(System.Globalization.CultureInfo.InvariantCulture)); return; }
        if (value is float) { float x=(float)value; if (Single.IsNaN(x)||Single.IsInfinity(x)) w.WriteValue(x.ToString(System.Globalization.CultureInfo.InvariantCulture)); else w.WriteValue(x); return; }
        if (value is double) { double x=(double)value; if (Double.IsNaN(x)||Double.IsInfinity(x)) w.WriteValue(x.ToString(System.Globalization.CultureInfo.InvariantCulture)); else w.WriteValue(x); return; }
        if (value is decimal) { w.WriteValue((decimal)value); return; }
        if (t.IsEnum) { w.WriteStartObject(); w.WritePropertyName("name"); w.WriteValue(value.ToString()); w.WritePropertyName("value"); Type et=Enum.GetUnderlyingType(t); if(et==typeof(byte)||et==typeof(ushort)||et==typeof(uint)||et==typeof(ulong)) w.WriteValue(Convert.ToUInt64(value).ToString(System.Globalization.CultureInfo.InvariantCulture)); else w.WriteValue(Convert.ToInt64(value)); w.WriteEndObject(); return; }
        if (value is DateTime || value is DateTimeOffset || value is Guid || value is TimeSpan || value is Type || value is IntPtr || value is UIntPtr)
        { w.WriteValue(value.ToString()); return; }
        byte[] binary = value as byte[];
        if (binary != null) { WriteBinary(w, binary, path, root); return; }
        ResourceRef rr;
        if (!Object.ReferenceEquals(value, root) && Resources.TryGetValue(value, out rr)) { WriteReference(w, rr); return; }
        if (!t.IsValueType)
        {
            string oldPath;
            if (Seen.TryGetValue(value, out oldPath)) { w.WriteStartObject(); w.WritePropertyName("$cycleRef"); w.WriteValue(oldPath); w.WriteEndObject(); return; }
            Seen[value] = path;
        }
        IDictionary dict = value as IDictionary;
        if (dict != null)
        {
            w.WriteStartArray(); int n=0;
            foreach (DictionaryEntry e in dict) { w.WriteStartObject(); w.WritePropertyName("key"); WriteAny(w,e.Key,path+".key"+n,root,depth+1); w.WritePropertyName("value"); WriteAny(w,e.Value,path+".value"+n,root,depth+1); w.WriteEndObject(); n++; }
            w.WriteEndArray(); return;
        }
        IEnumerable seq = value as IEnumerable;
        if (seq != null)
        {
            w.WriteStartArray(); int n=0;
            foreach (object x in seq) { WriteAny(w,x,path+"["+n+"]",root,depth+1); n++; }
            w.WriteEndArray(); return;
        }
        if (value is Delegate) { w.WriteStartObject(); w.WritePropertyName("$delegate"); w.WriteValue(t.FullName); w.WriteEndObject(); return; }
        string ns=t.Namespace ?? "";
        if (!ns.StartsWith("UndertaleModLib", StringComparison.Ordinal) && !t.IsValueType)
        { w.WriteStartObject(); w.WritePropertyName("$type"); w.WriteValue(t.FullName); if (!ns.StartsWith("ImageMagick", StringComparison.Ordinal)) { w.WritePropertyName("$value"); w.WriteValue(SafeToString(value)); } w.WriteEndObject(); return; }
        WriteReflectedObject(w,value,path,root,depth);
    }

    static void WriteReflectedObject(JsonTextWriter w, object value, string path, object root, int depth)
    {
        Type t=value.GetType(); w.WriteStartObject(); w.WritePropertyName("$type"); w.WriteValue(t.FullName);
        HashSet<string> names=new HashSet<string>(StringComparer.Ordinal);
        List<PropertyInfo> props=t.GetProperties(BindingFlags.Instance|BindingFlags.Public).Where(p=>p.CanRead && p.GetIndexParameters().Length==0).OrderBy(p=>p.Name,StringComparer.Ordinal).ToList();
        foreach(PropertyInfo p in props)
        {
            if (!names.Add(p.Name)) continue; w.WritePropertyName(p.Name);
            try { WriteAny(w,p.GetValue(value,null),path+"."+p.Name,root,depth+1); }
            catch(Exception ex) { WriteGetterError(w,ex); }
        }
        List<FieldInfo> fields=new List<FieldInfo>();
        for(Type q=t;q!=null && (q.Namespace??"").StartsWith("UndertaleModLib",StringComparison.Ordinal);q=q.BaseType)
            fields.AddRange(q.GetFields(BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic|BindingFlags.DeclaredOnly));
        foreach(FieldInfo f in fields.Where(f=>!f.IsStatic && !f.Name.StartsWith("<",StringComparison.Ordinal)).OrderBy(f=>f.Name,StringComparer.Ordinal))
        {
            if (!names.Add(f.Name)) continue; w.WritePropertyName(f.Name);
            try { WriteAny(w,f.GetValue(value),path+"."+f.Name,root,depth+1); }
            catch(Exception ex) { WriteGetterError(w,ex); }
        }
        w.WriteEndObject();
    }

    static void WriteGetterError(JsonTextWriter w, Exception ex)
    { ErrorCount++; w.WriteStartObject(); w.WritePropertyName("$unverified"); w.WriteValue("GETTER_ERROR"); w.WritePropertyName("error"); w.WriteValue(ex.GetBaseException().GetType().FullName+": "+ex.GetBaseException().Message); w.WriteEndObject(); }

    static void WriteReference(JsonTextWriter w, ResourceRef rr)
    { w.WriteStartObject(); w.WritePropertyName("$resourceRef"); w.WriteStartObject(); w.WritePropertyName("category");w.WriteValue(rr.Category);w.WritePropertyName("index");w.WriteValue(rr.Index);w.WritePropertyName("name");w.WriteValue(rr.Name);w.WriteEndObject();w.WriteEndObject(); }

    static void WriteBinary(JsonTextWriter w, byte[] bytes, string logicalPath, object root)
    {
        string sha=Sha256(bytes); string rel; ResourceRef rr;
        if (root != null && Resources.TryGetValue(root, out rr) && rr.Category == "EmbeddedAudio")
        {
            string ext=HasPrefix(bytes,Encoding.ASCII.GetBytes("OggS"))?"ogg":HasPrefix(bytes,Encoding.ASCII.GetBytes("RIFF"))?"wav":"bin";
            rel=Path.Combine("audio",rr.Index.ToString("D4")+"_"+SafeName(rr.Name)+"."+ext).Replace('\\','/');
        }
        else
        {
            rel=Path.Combine("blobs",sha+".bin").Replace('\\','/'); string full=Path.Combine(BlobRoot,sha+".bin");
            if(!File.Exists(full)) { File.WriteAllBytes(full,bytes); BinaryCount++; BinaryBytes+=bytes.LongLength; }
        }
        w.WriteStartObject();w.WritePropertyName("$binary");w.WriteStartObject();w.WritePropertyName("path");w.WriteValue(rel);w.WritePropertyName("length");w.WriteValue(bytes.LongLength);w.WritePropertyName("sha256");w.WriteValue(sha);w.WritePropertyName("logicalPath");w.WriteValue(logicalPath);w.WriteEndObject();w.WriteEndObject();
    }

    static void ExportAudio(UndertaleData data)
    {
        string dir=Path.Combine(OutputRoot,"audio");Directory.CreateDirectory(dir);
        for(int i=0;i<data.EmbeddedAudio.Count;i++)
        {
            UndertaleEmbeddedAudio a=data.EmbeddedAudio[i]; byte[] b=a.Data ?? new byte[0]; string ext=HasPrefix(b,Encoding.ASCII.GetBytes("OggS"))?"ogg":HasPrefix(b,Encoding.ASCII.GetBytes("RIFF"))?"wav":"bin";
            File.WriteAllBytes(Path.Combine(dir,i.ToString("D4")+"_"+SafeName(GetResourceName(a))+"."+ext),b);
        }
    }

    static void WriteMetadata(UndertaleData d, Dictionary<string,int> counts)
    {
        string path=Path.Combine(OutputRoot,"manifest.json");using(StreamWriter sw=new StreamWriter(path,false,new UTF8Encoding(false)))using(JsonTextWriter w=new JsonTextWriter(sw){Formatting=Formatting.Indented})
        { w.WriteStartObject();w.WritePropertyName("schema");w.WriteValue("no-name-village-utmt-extraction-v1");w.WritePropertyName("project");w.WriteValue(d.GeneralInfo.Name.Content);w.WritePropertyName("bytecodeVersion");w.WriteValue(d.GeneralInfo.BytecodeVersion);w.WritePropertyName("isGameMaker2");w.WriteValue(d.IsGameMaker2());w.WritePropertyName("isYYC");w.WriteValue(d.IsYYC());w.WritePropertyName("counts");w.WriteStartObject();foreach(var x in counts){w.WritePropertyName(x.Key);w.WriteValue(x.Value);}w.WriteEndObject();w.WritePropertyName("binaryBlobs");w.WriteValue(BinaryCount);w.WritePropertyName("binaryBytes");w.WriteValue(BinaryBytes);w.WritePropertyName("getterErrors");w.WriteValue(ErrorCount);w.WritePropertyName("flags");w.WriteStartObject();w.WritePropertyName("UnsupportedBytecodeVersion");w.WriteValue(d.UnsupportedBytecodeVersion);w.WritePropertyName("IsTPAG4ByteAligned");w.WriteValue(d.IsTPAG4ByteAligned);w.WritePropertyName("ShortCircuit");w.WriteValue(d.ShortCircuit);w.WritePropertyName("PaddingAlignException");w.WriteValue(d.PaddingAlignException);w.WritePropertyName("VarCount1");w.WriteValue((long)d.VarCount1);w.WritePropertyName("VarCount2");w.WriteValue((long)d.VarCount2);w.WritePropertyName("MaxLocalVarCount");w.WriteValue((long)d.MaxLocalVarCount);w.WriteEndObject();w.WriteEndObject(); }
    }

    static string GetResourceName(object x)
    {
        if(x==null)return null;try{PropertyInfo p=x.GetType().GetProperty("Name",BindingFlags.Instance|BindingFlags.Public);if(p!=null){object n=p.GetValue(x,null);UndertaleString us=n as UndertaleString;if(us!=null)return us.Content;if(n!=null)return n.ToString();}}catch{}return null;
    }
    static string SafeName(string s){if(String.IsNullOrEmpty(s))return "unnamed";StringBuilder b=new StringBuilder();foreach(char c in s)b.Append(Char.IsLetterOrDigit(c)||c=='.'||c=='-'||c=='_'?c:'_');return b.ToString();}
    static string SafeToString(object x){try{return x.ToString();}catch(Exception ex){return "UNVERIFIED: "+ex.GetType().Name;}}
    static bool HasPrefix(byte[] b,byte[] p){if(b.Length<p.Length)return false;for(int i=0;i<p.Length;i++)if(b[i]!=p[i])return false;return true;}
    static string Sha256(byte[] b){using(SHA256 h=SHA256.Create()){byte[] x=h.ComputeHash(b);StringBuilder s=new StringBuilder(x.Length*2);foreach(byte z in x)s.Append(z.ToString("x2"));return s.ToString();}}
    static void WriteErrorFile(string name,Exception ex){ErrorCount++;File.WriteAllText(Path.Combine(OutputRoot,"inventory",name+".error.txt"),ex.ToString());}
}
