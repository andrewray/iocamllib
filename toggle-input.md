Copy the following HTML into a notebook **markdown cell** and you can toggle input cells from displaying.

```
<script type="text/javascript">
    show=true;
    function toggle(){
        if (show){
            $('div.input').hide();
        }else{
            $('div.input').show();
        }
        show = !show
    }
</script>

<a href="javascript:toggle()" target="_self">toggle input</a>
```

