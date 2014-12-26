package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorLevel;

	public interface Change {
		function doChange(editor:EditorLevel):void;
		function undoChange(editor:EditorLevel):void;
	}
}
